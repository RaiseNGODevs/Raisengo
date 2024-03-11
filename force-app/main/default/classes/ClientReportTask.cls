public class ClientReportTask {

    public Date executionDate 	{get; set;}
    public String taskName 		{get; set;}
    public String notes 	{get; set;}
    public Decimal duration 	{get; set;}
    
    public ClientReportTask(TASKRAY__trTaskTime__c taskTime){
        this.taskName = taskTime.TASKRAY__Task__r.Name.escapeEcmaScript();
        this.executionDate = taskTime.TASKRAY__Date__c;
        this.duration = taskTime.TASKRAY__Hours__c;
        if( String.isNotBlank(taskTime.TASKRAY__Notes__c) )
        	this.notes = taskTime.TASKRAY__Notes__c.escapeEcmaScript();
    }
    
    public static List<ClientReportTask> getClientReportTasks(List<TASKRAY__trTaskTime__c> taskTimes){
        List<ClientReportTask> taskList = new List<ClientReportTask>();
        for( TASKRAY__trTaskTime__c taskTime : taskTimes ){
            if( String.isNotBlank(taskTime.TASKRAY__Notes__c) )
            	taskList.add(new ClientReportTask(taskTime));
        }
        return taskList;
    }
    
}