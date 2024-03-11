@isTest
public class TaskrayTaskTriggerHandlerTest {
    @isTest
    public static void test(){
        String projectName = 'Test Project', taskName = 'Test Task', timeName = 'TIME-1', timeNote = 'DG: Time Note';
        Date taskTimeDate = Date.today();
        Decimal contractedHours = 10, timeHours = 3;
        TASKRAY__Project__c project = new TASKRAY__Project__c(Name = projectName, Contracted_Hours__c = contractedHours);
        insert project;
        TASKRAY__Project_Task__c task = new TASKRAY__Project_Task__c(Name = taskName, TASKRAY__Project__c = project.Id);
        insert task;
        update task;
    }
    
    @isTest
    public static void test2(){
        String projectName = 'Test Project2', taskName = 'Test Task Support', timeName = 'TIME-1', timeNote = 'DG: Time Note';
        Date taskTimeDate = Date.today();
        Decimal contractedHours = 10, timeHours = 3;
        TASKRAY__Project__c project = new TASKRAY__Project__c(Name = projectName, Contracted_Hours__c = contractedHours);
        insert project;
        TASKRAY__Project_Task__c task = new TASKRAY__Project_Task__c(Name = taskName, TASKRAY__Project__c = project.Id,Task_Type__c='Support',SLA__c='SL1',TASKRAY__trCompleted__c=true,Close_Date__c=system.TODAY()+1);
        insert task;
        update task;
    }
}