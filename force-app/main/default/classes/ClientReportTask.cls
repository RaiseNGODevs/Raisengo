public class ClientReportTask {

    public Date executionDate 	{get; set;}
    public String taskName 		{get; set;}
    public String notes 	{get; set;}
    public Decimal duration 	{get; set;}
    
    public ClientReportTask(TimeEntry__c taskTime){
        this.taskName = taskTime.CaseId__r == null ? '' : taskTime.CaseId__r.Subject.escapeEcmaScript();
        this.executionDate = taskTime.StartTime__c.date();
        this.duration = taskTime.TrackedTime__c;
        if( String.isNotBlank(taskTime.Description__c) )
        	this.notes = taskTime.Description__c.escapeEcmaScript();
    }
    
    public static List<ClientReportTask> getClientReportTasks(List<TimeEntry__c> taskTimes){
        List<ClientReportTask> taskList = new List<ClientReportTask>();
        for( TimeEntry__c taskTime : taskTimes ){
            if( String.isNotBlank(taskTime.Description__c) )
            	taskList.add(new ClientReportTask(taskTime));
        }
        return taskList;
    }
}