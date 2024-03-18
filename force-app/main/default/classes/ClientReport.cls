public class ClientReport {
    public String projectId		{get; set;}
    public String title 			{get; set;}
    public Date startDate 			{get; set;}
    public Decimal contractedHours	{get; set;}
    public List<ClientReportTask> tasks 	{get; set;} 
    
    public ClientReport(String projectId){
        this.projectId = projectId;
        if( this.isValidProjectId() ){
            setReportData();
        }
    }
    
    public void setReportData(){
        List<ServiceContract> project = [SELECT Id, Name, TotalHoursPerContract__c, StartDate,
                                        (SELECT Id, CaseId__r.Subject, StartTime__c, TrackedTime__c/*, Description__c*/ 
                                        FROM Time_Entries__r 
                                        WHERE isBillable__c = true 
                                        ORDER BY StartTime__c DESC)
                                    FROM ServiceContract 
                                    WHERE Id = :projectId];
        if( !project.isEmpty() ){
        	this.title = project[0].Name.escapeEcmaScript();
            this.contractedHours = project[0].TotalHoursPerContract__c;
        	this.tasks = ClientReportTask.getClientReportTasks(project[0].Time_Entries__r);
            this.startDate = project[0].StartDate;
        }
    }
    
    public Boolean isValidProjectId(){
        return projectId != null && Pattern.matches('[A-Za-z0-9]{15}([A-Za-z0-9]{3}){0,1}', projectId);
    }
}