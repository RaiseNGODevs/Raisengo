@isTest
public with sharing class DeleteLogs_TEST {
    @testSetup
    static void init() {
        ClockifySettings__c cS = new ClockifySettings__c();
        cS.LogsLifeTime__c = 30;
        insert cS;
    }
	@isTest
    static void testBatch() {
        Integration_Log__c log = new Integration_Log__c();
        log.Source__c = 'Clockify-API';
        insert log;
        id logId = log.id;
        Test.setCreatedDate(logId, Date.today().addDays(-31));
        Test.startTest();
        Database.executeBatch(new DeleteLogs_Batch());
        Test.stopTest();
        System.assertEquals(0, [SELECT count() FROM Integration_Log__c WHERE id =: logId]);
    }
    
    @isTest
    static void testBatchNegative() {
        Integration_Log__c log = new Integration_Log__c();
        log.Source__c = 'Clockify-API';
        insert log;
        id logId = log.id;
        Test.setCreatedDate(logId, Date.today().addDays(-20));
        Test.startTest();
        Database.executeBatch(new DeleteLogs_Batch());
        Test.stopTest();
        System.assertEquals(1, [SELECT count() FROM Integration_Log__c WHERE id =: logId]);
    }
    @isTest
    static void testSchedule() {
        Integration_Log__c log = new Integration_Log__c();
        log.Source__c = 'Clockify-API';
        insert log;
        id logId = log.id;
        Test.setCreatedDate(logId, Date.today().addDays(-20));
        Test.startTest();
        System.schedule('Teste', '0 0 4 ? * SUN *', new DeleteLogs_Batch());
        Database.executeBatch(new DeleteLogs_Batch());
        Test.stopTest();
        System.assertEquals(1, [SELECT count() FROM Integration_Log__c WHERE id =: logId]);
    }
}