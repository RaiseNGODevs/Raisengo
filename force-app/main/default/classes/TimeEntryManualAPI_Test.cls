@isTest
public with sharing class TimeEntryManualAPI_Test {

    @testSetup 
    static void init() {

        ClockifySettings__c clockS = new ClockifySettings__c();
        clockS.workspaceId__c = '1';
        clockS.Signing_Update_Key__c = '2';
        clockS.Signing_Stop_Key__c = '3';
        clockS.Signing_Delete_Key__c = '4';
        clockS.Signing_Create_Key__c = '5';
        insert clockS;
        
        Account a = new Account();
        a.Name = 'Teste Client';
        a.ClockifyClientId__c = '6';
        insert a;

        ServiceContract cront = new ServiceContract();
        cront.Name = 'Teste';
        cront.AccountId = a.ID;
        cront.ClockifyProjectId__c = '7';
        insert cront;

        Case cas = new Case();
        cas.Origin = 'Email';
        cas.Subject = 'Teste Task';
        cas.Clockify_Task_Id__c = '8';
        insert cas;

        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com.user',
            ClockifyUserId__c = '9');
        insert u;
        
        TimeEntry__c te = new TimeEntry__c();
        te.ClockifyTimeEntryId__c = '11';
        te.CaseId__c = cas.Id;
        te.Description__c = 'Teste';
        te.StartTime__c = DateTime.now();
        te.EndTime__c = DateTime.now().addMinutes(5);
        insert te;

    }
    @isTest
    static void successTimerStoped(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String requestBody = '{"id":"10","description":"Teste","userId":"9","billable":false,"projectId":"7","timeInterval":{"start":"2024-01-31T14:03:34Z","end":"2024-01-31T14:04:25Z","duration":"PT51S"},"workspaceId":"1","isLocked":false,"hourlyRate":null,"costRate":null,"customFieldValues":[{"customFieldId":"64bfde89988d867972796f08","timeEntryId":"10","value":"Internal Work","name":"Project Type"},{"customFieldId":"64bfe10f988d86797279c4cf","timeEntryId":"10","value":"In progress","name":"Project Status"}],"type":"REGULAR","kioskId":null,"projectCurrency":null,"currentlyRunning":false,"project":{"name":"Projeto Suporte Expcloud","clientId":"6","workspaceId":"1","billable":false,"estimate":{"estimate":"PT0S","type":"AUTO"},"color":"#E91E63","archived":false,"clientName":"Raise NGO","duration":"PT197H31M18S","note":"","activeEstimate":"NONE","timeEstimate":{"includeNonBillable":true,"estimate":0,"type":"AUTO","resetOption":null},"budgetEstimate":null,"estimateReset":null,"id":"7","public":true,"template":false},"task":{"workspaceId":"1","userGroupIds":[],"status":"ACTIVE","projectId":"7","name":"Development","id":"8","hourlyRate":null,"estimate":"PT0S","duration":"PT36H30M","costRate":null,"budgetEstimate":0,"billable":false,"assigneeIds":[],"assigneeId":""},"user":{"id":"9","name":"Rafael Borges Monteiro","status":"ACTIVE"},"tags":[]}';
        req.requestURI = '/services/apexrest/time-entry/'; 
        req.httpMethod = 'POST';
        req.requestBody = Blob.ValueOf(requestBody);
        RestContext.request = req;
        RestContext.response= res;
        req.addHeader('Clockify-Webhook-Event-Type', 'TIMER_STOPPED');
        req.addHeader('Clockify-Signature', '3');
        Test.startTest();
        TimeEntryManualAPI.doPost();
        Test.stopTest();
        System.assertEquals(1,[SELECT count() FROM TimeEntry__c WHERE ClockifyTimeEntryId__c = '10'], 'Didnt create the time entry'); 
    }
    @isTest
    static void successCreate(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String requestBody = '{"id":"10","description":"Teste","userId":"9","billable":false,"projectId":"7","timeInterval":{"start":"2024-01-31T14:03:34Z","end":"2024-01-31T14:04:25Z","duration":"PT51S"},"workspaceId":"1","isLocked":false,"hourlyRate":null,"costRate":null,"customFieldValues":[{"customFieldId":"64bfde89988d867972796f08","timeEntryId":"10","value":"Internal Work","name":"Project Type"},{"customFieldId":"64bfe10f988d86797279c4cf","timeEntryId":"10","value":"In progress","name":"Project Status"}],"type":"REGULAR","kioskId":null,"projectCurrency":null,"currentlyRunning":false,"project":{"name":"Projeto Suporte Expcloud","clientId":"6","workspaceId":"1","billable":false,"estimate":{"estimate":"PT0S","type":"AUTO"},"color":"#E91E63","archived":false,"clientName":"Raise NGO","duration":"PT197H31M18S","note":"","activeEstimate":"NONE","timeEstimate":{"includeNonBillable":true,"estimate":0,"type":"AUTO","resetOption":null},"budgetEstimate":null,"estimateReset":null,"id":"7","public":true,"template":false},"task":{"workspaceId":"1","userGroupIds":[],"status":"ACTIVE","projectId":"7","name":"Development","id":"8","hourlyRate":null,"estimate":"PT0S","duration":"PT36H30M","costRate":null,"budgetEstimate":0,"billable":false,"assigneeIds":[],"assigneeId":""},"user":{"id":"9","name":"Rafael Borges Monteiro","status":"ACTIVE"},"tags":[]}';
        req.requestURI = '/services/apexrest/time-entry/'; 
        req.httpMethod = 'POST';
        req.requestBody = Blob.ValueOf(requestBody);
        RestContext.request = req;
        RestContext.response= res;
        req.addHeader('Clockify-Webhook-Event-Type', 'NEW_TIME_ENTRY');
        req.addHeader('Clockify-Signature', '5');
        Test.startTest();
        TimeEntryManualAPI.doPost();
        Test.stopTest();
        System.assertEquals(1,[SELECT count() FROM TimeEntry__c WHERE ClockifyTimeEntryId__c = '10'], 'Didnt create the time entry'); 
    }
    @isTest
    static void ignoredCreateFailedValidation(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String requestBody = '{"id":"10","description":"Teste","userId":null,"billable":false,"projectId":null,"timeInterval":{"start":"2024-01-31T14:03:34Z","end":"2024-01-31T14:04:25Z","duration":"PT51S"},"workspaceId":"1","isLocked":false,"hourlyRate":null,"costRate":null,"customFieldValues":[{"customFieldId":"64bfde89988d867972796f08","timeEntryId":"10","value":"Internal Work","name":"Project Type"},{"customFieldId":"64bfe10f988d86797279c4cf","timeEntryId":"10","value":"In progress","name":"Project Status"}],"type":"REGULAR","kioskId":null,"projectCurrency":null,"currentlyRunning":false,"project":{"name":"Projeto Suporte Expcloud","clientId":"6","workspaceId":"1","billable":false,"estimate":{"estimate":"PT0S","type":"AUTO"},"color":"#E91E63","archived":false,"clientName":"Raise NGO","duration":"PT197H31M18S","note":"","activeEstimate":"NONE","timeEstimate":{"includeNonBillable":true,"estimate":0,"type":"AUTO","resetOption":null},"budgetEstimate":null,"estimateReset":null,"id":"7","public":true,"template":false},"task":{"workspaceId":"1","userGroupIds":[],"status":"ACTIVE","projectId":"7","name":"Development","id":"8","hourlyRate":null,"estimate":"PT0S","duration":"PT36H30M","costRate":null,"budgetEstimate":0,"billable":false,"assigneeIds":[],"assigneeId":""},"user":{"id":"9","name":"Rafael Borges Monteiro","status":"ACTIVE"},"tags":[]}';
        req.requestURI = '/services/apexrest/time-entry/'; 
        req.httpMethod = 'POST';
        req.requestBody = Blob.ValueOf(requestBody);
        RestContext.request = req;
        RestContext.response= res;
        req.addHeader('Clockify-Webhook-Event-Type', 'NEW_TIME_ENTRY');
        req.addHeader('Clockify-Signature', '5');
        Test.startTest();
        TimeEntryManualAPI.doPost();
        Test.stopTest();
        Assert.isFalse([SELECT ID FROM Integration_Log__c WHERE Result__c = 'Ignored'].isEmpty(), 'Didnt create the integration log'); 
    }
    @isTest
    static void successUpdate(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String requestBody = '{"id":"11","description":"Teste","userId":"9","billable":false,"projectId":"7","timeInterval":{"start":"2024-01-31T14:00:00Z","end":"2024-01-31T15:00:00Z","duration":"PT51S"},"workspaceId":"1","isLocked":false,"hourlyRate":null,"costRate":null,"customFieldValues":[{"customFieldId":"64bfde89988d867972796f08","timeEntryId":"10","value":"Internal Work","name":"Project Type"},{"customFieldId":"64bfe10f988d86797279c4cf","timeEntryId":"10","value":"In progress","name":"Project Status"}],"type":"REGULAR","kioskId":null,"projectCurrency":null,"currentlyRunning":false,"project":{"name":"Projeto Suporte Expcloud","clientId":"6","workspaceId":"1","billable":false,"estimate":{"estimate":"PT0S","type":"AUTO"},"color":"#E91E63","archived":false,"clientName":"Raise NGO","duration":"PT197H31M18S","note":"","activeEstimate":"NONE","timeEstimate":{"includeNonBillable":true,"estimate":0,"type":"AUTO","resetOption":null},"budgetEstimate":null,"estimateReset":null,"id":"7","public":true,"template":false},"task":{"workspaceId":"1","userGroupIds":[],"status":"ACTIVE","projectId":"7","name":"Development","id":"8","hourlyRate":null,"estimate":"PT0S","duration":"PT36H30M","costRate":null,"budgetEstimate":0,"billable":false,"assigneeIds":[],"assigneeId":""},"user":{"id":"9","name":"Rafael Borges Monteiro","status":"ACTIVE"},"tags":[]}';
        req.requestURI = '/services/apexrest/time-entry/'; 
        req.httpMethod = 'POST';
        req.requestBody = Blob.ValueOf(requestBody);
        RestContext.request = req;
        RestContext.response= res;
        req.addHeader('Clockify-Webhook-Event-Type', 'TIME_ENTRY_UPDATED');
        req.addHeader('Clockify-Signature', '2');
        Test.startTest();
        TimeEntryManualAPI.doPost();
        Test.stopTest();
        TimeEntry__c entry = [SELECT ID, StartTime__c, EndTime__c FROM TimeEntry__c WHERE ClockifyTimeEntryId__c = '11'];
        Assert.isNotNull(entry, 'Didnt update the time entry');
        Assert.areEqual(DateTime.newInstance(2024, 01, 31, 14, 00, 00), entry.StartTime__c, 'Didnt update with the right value, Actual: '+entry.StartTime__c);
        Assert.areEqual(DateTime.newInstance(2024, 01, 31, 15, 00, 00), entry.EndTime__c, 'Didnt update with the right value, Actual: '+entry.EndTime__c);
    }
    @isTest
    static void ignoredUpdateFailedValidation(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String requestBody = '{"id":"11","description":"Teste","userId":null,"billable":false,"projectId":null,"timeInterval":{"start":"2024-01-31T14:03:34Z","end":"2024-01-31T14:04:25Z","duration":"PT51S"},"workspaceId":"1","isLocked":false,"hourlyRate":null,"costRate":null,"customFieldValues":[{"customFieldId":"64bfde89988d867972796f08","timeEntryId":"10","value":"Internal Work","name":"Project Type"},{"customFieldId":"64bfe10f988d86797279c4cf","timeEntryId":"10","value":"In progress","name":"Project Status"}],"type":"REGULAR","kioskId":null,"projectCurrency":null,"currentlyRunning":false,"project":{"name":"Projeto Suporte Expcloud","clientId":"6","workspaceId":"1","billable":false,"estimate":{"estimate":"PT0S","type":"AUTO"},"color":"#E91E63","archived":false,"clientName":"Raise NGO","duration":"PT197H31M18S","note":"","activeEstimate":"NONE","timeEstimate":{"includeNonBillable":true,"estimate":0,"type":"AUTO","resetOption":null},"budgetEstimate":null,"estimateReset":null,"id":"7","public":true,"template":false},"task":{"workspaceId":"1","userGroupIds":[],"status":"ACTIVE","projectId":"7","name":"Development","id":"8","hourlyRate":null,"estimate":"PT0S","duration":"PT36H30M","costRate":null,"budgetEstimate":0,"billable":false,"assigneeIds":[],"assigneeId":""},"user":{"id":"9","name":"Rafael Borges Monteiro","status":"ACTIVE"},"tags":[]}';
        req.requestURI = '/services/apexrest/time-entry/'; 
        req.httpMethod = 'POST';
        req.requestBody = Blob.ValueOf(requestBody);
        RestContext.request = req;
        RestContext.response= res;
        req.addHeader('Clockify-Webhook-Event-Type', 'TIME_ENTRY_UPDATED');
        req.addHeader('Clockify-Signature', '2');
        Test.startTest();
        TimeEntryManualAPI.doPost();
        Test.stopTest();
        Assert.isFalse([SELECT ID FROM Integration_Log__c WHERE Result__c = 'Ignored'].isEmpty(), 'Didnt create the integration log'); 
    }
    @isTest
    static void successDelete(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String requestBody = '{"id":"11","description":"Teste","userId":"9","billable":false,"projectId":"7","timeInterval":{"start":"2024-01-31T14:00:00Z","end":"2024-01-31T15:00:00Z","duration":"PT51S"},"workspaceId":"1","isLocked":false,"hourlyRate":null,"costRate":null,"customFieldValues":[{"customFieldId":"64bfde89988d867972796f08","timeEntryId":"10","value":"Internal Work","name":"Project Type"},{"customFieldId":"64bfe10f988d86797279c4cf","timeEntryId":"10","value":"In progress","name":"Project Status"}],"type":"REGULAR","kioskId":null,"projectCurrency":null,"currentlyRunning":false,"project":{"name":"Projeto Suporte Expcloud","clientId":"6","workspaceId":"1","billable":false,"estimate":{"estimate":"PT0S","type":"AUTO"},"color":"#E91E63","archived":false,"clientName":"Raise NGO","duration":"PT197H31M18S","note":"","activeEstimate":"NONE","timeEstimate":{"includeNonBillable":true,"estimate":0,"type":"AUTO","resetOption":null},"budgetEstimate":null,"estimateReset":null,"id":"7","public":true,"template":false},"task":{"workspaceId":"1","userGroupIds":[],"status":"ACTIVE","projectId":"7","name":"Development","id":"8","hourlyRate":null,"estimate":"PT0S","duration":"PT36H30M","costRate":null,"budgetEstimate":0,"billable":false,"assigneeIds":[],"assigneeId":""},"user":{"id":"9","name":"Rafael Borges Monteiro","status":"ACTIVE"},"tags":[]}';
        req.requestURI = '/services/apexrest/time-entry/'; 
        req.httpMethod = 'POST';
        req.requestBody = Blob.ValueOf(requestBody);
        RestContext.request = req;
        RestContext.response= res;
        req.addHeader('Clockify-Webhook-Event-Type', 'TIME_ENTRY_DELETED');
        req.addHeader('Clockify-Signature', '4');
        Test.startTest();
        TimeEntryManualAPI.doPost();
        Test.stopTest();
        List<TimeEntry__c> entry = new List<TimeEntry__c>();
        entry.addAll([SELECT ID FROM TimeEntry__c WHERE ClockifyTimeEntryId__c = '11']);
        Assert.isTrue(entry.isEmpty(), 'Didnt delete the time entry');
    }
    @isTest
    static void IgnoredUnsupportedMethod(){
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String requestBody = '{"id":"11","description":"Teste","userId":null,"billable":false,"projectId":null,"timeInterval":{"start":"2024-01-31T14:03:34Z","end":"2024-01-31T14:04:25Z","duration":"PT51S"},"workspaceId":"1","isLocked":false,"hourlyRate":null,"costRate":null,"customFieldValues":[{"customFieldId":"64bfde89988d867972796f08","timeEntryId":"10","value":"Internal Work","name":"Project Type"},{"customFieldId":"64bfe10f988d86797279c4cf","timeEntryId":"10","value":"In progress","name":"Project Status"}],"type":"REGULAR","kioskId":null,"projectCurrency":null,"currentlyRunning":false,"project":{"name":"Projeto Suporte Expcloud","clientId":"6","workspaceId":"1","billable":false,"estimate":{"estimate":"PT0S","type":"AUTO"},"color":"#E91E63","archived":false,"clientName":"Raise NGO","duration":"PT197H31M18S","note":"","activeEstimate":"NONE","timeEstimate":{"includeNonBillable":true,"estimate":0,"type":"AUTO","resetOption":null},"budgetEstimate":null,"estimateReset":null,"id":"7","public":true,"template":false},"task":{"workspaceId":"1","userGroupIds":[],"status":"ACTIVE","projectId":"7","name":"Development","id":"8","hourlyRate":null,"estimate":"PT0S","duration":"PT36H30M","costRate":null,"budgetEstimate":0,"billable":false,"assigneeIds":[],"assigneeId":""},"user":{"id":"9","name":"Rafael Borges Monteiro","status":"ACTIVE"},"tags":[]}';
        req.requestURI = '/services/apexrest/time-entry/'; 
        req.httpMethod = 'POST';
        req.requestBody = Blob.ValueOf(requestBody);
        RestContext.request = req;
        RestContext.response= res;
        req.addHeader('Clockify-Webhook-Event-Type', 'TIME_ENTRY_UNSUPPORTED');
        req.addHeader('Clockify-Signature', '');
        Test.startTest();
        TimeEntryManualAPI.doPost();
        Test.stopTest();
        Assert.isFalse([SELECT ID FROM Integration_Log__c WHERE Result__c = 'Ignored'].isEmpty(), 'Didnt create the integration log'); 
    }
}