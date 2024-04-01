public class ProjectHoursCalculator_Batch implements Database.Batchable<sObject>, Schedulable{

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, RemainingTotalHours__c, RemainingMonthlyHours__c, TotalHoursPerContract__c, MonthlyHoursPerContract__c
                                        FROM ServiceContract 
                                        WHERE IsDeleted = FALSE 
                                        AND Status = 'Active']);
    }
    public void execute(Database.BatchableContext bc, List<ServiceContract> scope){
        try{
            ServiceContract sContract = scope[0];
            List<TimeEntry__c> tEntrys = new List<TimeEntry__c>();
            tEntrys.addAll([SELECT ID, TrackedTime__c, CreatedDate
                            FROM TimeEntry__c
                            WHERE Service_Contract__c =:sContract.Id
                            AND isBillable__c = true]);
            Decimal totalHours = sContract.TotalHoursPerContract__c == null ? 0 : sContract.TotalHoursPerContract__c;
            Decimal monthHours = sContract.MonthlyHoursPerContract__c == null ? 0 : sContract.MonthlyHoursPerContract__c;
            for (TimeEntry__c entry : tEntrys) {
                totalHours -= entry.TrackedTime__c;
                if(entry.CreatedDate.month() == Date.today().month()){
                    monthHours -= entry.TrackedTime__c;
                }
            }
            if(sContract.RemainingTotalHours__c != totalHours || sContract.RemainingMonthlyHours__c != monthHours){
                sContract.RemainingTotalHours__c = totalHours;
                sContract.RemainingMonthlyHours__c = monthHours;
                update sContract;
            }   
        }catch(Exception error){
            new IntegrationLogCreator('ProjectHoursCalculator_Batch', 'execute', Json.serialize(new Map<String,String>{'error' => error.getTypeName(), 'message' => error.getMessage(), 'line' => String.valueOf(error.getLineNumber())}), 'Failure', null).publish();
        }
    }
    public void finish(Database.BatchableContext bc){
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                        TotalJobItems, CreatedBy.Email
                        FROM AsyncApexJob 
                        WHERE Id = :bc.getJobId()];
                        new IntegrationLogCreator('ProjectHoursCalculator_Batch', 'finish', Json.serialize(new Map<String,String>{'JobItemsProcessed' => String.valueOf(a.JobItemsProcessed), 'Status' => a.Status, 'TotalJobItems' => String.valueOf(a.TotalJobItems)}), 'Success', null).publish();
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new ProjectHoursCalculator_Batch(), 1);
    }
}