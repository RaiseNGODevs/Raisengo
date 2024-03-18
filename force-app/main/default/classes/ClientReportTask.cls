public class ClientReportTask {

    public Date executionDate 	{get; set;}
    public String taskName 		{get; set;}
    public String notes 	{get; set;}
    public Decimal duration 	{get; set;}
    
    public ClientReportTask(TimeEntry__c taskTime){
        this.taskName = taskTime.CaseId__r == null ? '' : getCleanString(taskTime.CaseId__r.Subject);
        this.executionDate = taskTime.StartTime__c.date();
        this.duration = taskTime.TrackedTime__c;
        if( String.isNotBlank(taskTime.Description__c) )
        	this.notes = getCleanString(taskTime.Description__c);
    }
    
    public static List<ClientReportTask> getClientReportTasks(List<TimeEntry__c> taskTimes){
        List<ClientReportTask> taskList = new List<ClientReportTask>();
        for( TimeEntry__c taskTime : taskTimes ){
            if( String.isNotBlank(taskTime.Description__c) )
            	taskList.add(new ClientReportTask(taskTime));
        }
        return taskList;
    }

    public static String getCleanString(String inputString) {
        if (String.isBlank(inputString)) return '';
        String cleanedString = inputString.replaceAll('[áãâàä]', 'a')
                                         .replaceAll('[éêèë]', 'e')
                                         .replaceAll('[íîìï]', 'i')
                                         .replaceAll('[óõôòö]', 'o')
                                         .replaceAll('[úûùü]', 'u')
                                         .replaceAll('[ç]', 'c');
        cleanedString = cleanedString.replaceAll('[^a-zA-Z0-9\\s]', '');
        cleanedString = cleanedString.replaceAll('\\r\\n|\\n|\\r', ' ');
        return cleanedString;
    }
}