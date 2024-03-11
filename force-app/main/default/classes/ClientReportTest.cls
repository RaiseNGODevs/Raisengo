@isTest
public class ClientReportTest {
	
    @isTest
    public static void reportCreation(){
        String projectName = 'Test Project', taskName = 'Test Task', timeName = 'TIME-1', timeNote = 'DG: Time Note';
        Date taskTimeDate = Date.today();
        Decimal contractedHours = 10, timeHours = 3;
        TASKRAY__Project__c project = new TASKRAY__Project__c(Name = projectName, Contracted_Hours__c = contractedHours);
        insert project;
        TASKRAY__Project_Task__c task = new TASKRAY__Project_Task__c(Name = taskName, TASKRAY__Project__c = project.Id);
        insert task;
       	TASKRAY__trTaskTime__c taskrayTime = new TASKRAY__trTaskTime__c(TASKRAY__Project__c = project.Id, TASKRAY__Hours__c = timeHours, TASKRAY__Billable__c = true, 
                                                                        TASKRAY__Notes__c = timeNote, TASKRAY__Date__c = taskTimeDate, TASKRAY__Task__c = task.Id);
        insert taskrayTime;
        ClientReport report = new ClientReport(project.Id);
        
        System.assert(report.projectId == project.Id);
        System.assert(report.title == projectName);
        System.assert(report.contractedHours == contractedHours);
        System.assert(report.tasks != null);
        for( ClientReportTask reportTask : report.tasks ){
        	System.assertEquals(taskTimeDate, reportTask.executionDate);
            System.assertEquals(taskName, reportTask.taskName);
            System.assertEquals(timeNote, reportTask.notes);
        	System.assertEquals(timeHours, reportTask.duration);
        }
    }
    
    @isTest
    public static void clientReportController(){
        ApexPages.currentPage().getParameters().put('pId','000000000000000');
        new ClientReportController();
    }
    
}