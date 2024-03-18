@isTest
public class ClientReportTest {
	
    @isTest
    public static void reportCreation(){
        String projectName = 'Test Project', taskName = 'Test Task', timeName = 'TIME-1', timeNote = 'DG Time Note';
        DateTime startDate = Datetime.now().addHours(-3);
        DateTime endDate = Datetime.now();
        Decimal contractedHours = 10, timeHours = 3;
        ServiceContract project = new ServiceContract(Name = projectName, TotalHoursPerContract__c = contractedHours);
        insert project;
        Case task = new Case(Subject = taskName, Service_Contract__c = project.Id, Status = 'New', Origin = 'Email');
        insert task;
       	TimeEntry__c timeEntry = new TimeEntry__c(Service_Contract__c = project.Id,  isBillable__c = true, 
                                                                        Description__c = timeNote, StartTime__c = startDate, EndTime__c = endDate, CaseId__c = task.ID);
        insert timeEntry;
        ClientReport report = new ClientReport(project.Id);
        
        System.assert(report.projectId == project.Id);
        System.assert(report.title == projectName);
        System.assert(report.contractedHours == contractedHours);
        System.assert(report.tasks != null);
        for( ClientReportTask reportTask : report.tasks ){
        	System.assertEquals(Date.today(), reportTask.executionDate);
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