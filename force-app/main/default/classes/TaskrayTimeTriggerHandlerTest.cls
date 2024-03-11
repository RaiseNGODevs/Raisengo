@isTest
public class TaskrayTimeTriggerHandlerTest {
	
    @isTest
    public static void test(){
        String projectName = 'Test Project', taskName = 'Test Task', timeName = 'TIME-1', timeNote = 'DG: Time Note';
        Date taskTimeDate = Date.today();
        Decimal contractedHours = 10, timeHours = 3;
        TASKRAY__Project__c project = new TASKRAY__Project__c(Name = projectName, Contracted_Hours__c = contractedHours);
        insert project;
        TASKRAY__Project_Task__c task = new TASKRAY__Project_Task__c(Name = taskName, TASKRAY__Project__c = project.Id);
        insert task;
       	TASKRAY__trTaskTime__c taskrayTime = new TASKRAY__trTaskTime__c(TASKRAY__Project__c = project.Id, TASKRAY__Hours__c = timeHours, 
                                                                        TASKRAY__Notes__c = timeNote, TASKRAY__Date__c = taskTimeDate, TASKRAY__Task__c = task.Id);
        insert taskrayTime;
        update taskrayTime;
    }
    
}