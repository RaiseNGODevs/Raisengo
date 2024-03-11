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
        List<TASKRAY__Project__c> project = [SELECT Id, Name, Contracted_Hours__c, Contracted_Start_Date__c,
                                             (SELECT Id, TASKRAY__Task__r.Name, TASKRAY__Date__c, TASKRAY__Hours__c, TASKRAY__Notes__c 
                                              FROM TASKRAY__TaskRay_Time__r WHERE TASKRAY__Billable__c = true ORDER BY TASKRAY__Date__c DESC) 
                                       		FROM TASKRAY__Project__c WHERE Id = :projectId];
        if( !project.isEmpty() ){
        	this.title = project[0].Name.escapeEcmaScript();
            this.contractedHours = project[0].Contracted_Hours__c;
        	this.tasks = ClientReportTask.getClientReportTasks(project[0].TASKRAY__TaskRay_Time__r);
            this.startDate = project[0].Contracted_Start_Date__c;
        }
    }
    
    public Boolean isValidProjectId(){
        return projectId != null && Pattern.matches('[A-Za-z0-9]{15}([A-Za-z0-9]{3}){0,1}', projectId);
    }
}