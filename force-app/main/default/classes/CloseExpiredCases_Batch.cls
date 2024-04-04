public class CloseExpiredCases_Batch implements Database.Batchable<sObject>, Schedulable{

    public Database.QueryLocator start(Database.BatchableContext bc) {
        Date dateToday = Date.today();
        dateToday.addDays(-7);
        return Database.getQueryLocator([SELECT Id, Status, LastModifiedDate
                                        FROM Case
                                        WHERE LastModifiedDate <: dateToday AND Status != 'Closed']);
    }
    public void execute(Database.BatchableContext bc, List<Case> scope){
        try{
            List<Case> toUpdate = new List<Case>();
            for (Case c : scope) {
                c.Status = 'Closed';
                c.Resolution__c = 'Client Unavailable';
                toUpdate.add(c);
            }
            update toUpdate;
        }catch(Exception error){
            new IntegrationLogCreator('CloseExpiredCases_Batch', 'execute', Json.serialize(new Map<String,String>{'error' => error.getTypeName(), 'message' => error.getMessage(), 'line' => String.valueOf(error.getLineNumber())}), 'Failure', null).publish();
        }
    }
    public void finish(Database.BatchableContext bc){
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                        TotalJobItems, CreatedBy.Email
                        FROM AsyncApexJob 
                        WHERE Id = :bc.getJobId()];
        new IntegrationLogCreator('CloseExpiredCases_Batch', 'finish', Json.serialize(new Map<String,String>{'JobItemsProcessed' => String.valueOf(a.JobItemsProcessed), 'Status' => a.Status, 'TotalJobItems' => String.valueOf(a.TotalJobItems)}), 'Success', null).publish();
    }
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new CloseExpiredCases_Batch(), 200);
    }
}