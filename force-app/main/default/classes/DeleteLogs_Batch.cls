public class DeleteLogs_Batch implements Database.Batchable<sObject>, Schedulable{
    public Database.QueryLocator start(Database.BatchableContext bc) {
        Integer days = Integer.ValueOf(ClockifySettings__c.getInstance().LogsLifeTime__c);
        Date deleteDate = Date.today().addDays(-days);
        return Database.getQueryLocator([SELECT Id 
                                        FROM Integration_Log__c 
                                        WHERE CreatedDate <: deleteDate
                                        AND Source__c = 'Clockify-API']);
    }
    public void execute(Database.BatchableContext bc, List<Integration_Log__c> scope){
        Database.delete(scope, false);
    }
    public void finish(Database.BatchableContext bc){}
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new DeleteLogs_Batch());
    }
}