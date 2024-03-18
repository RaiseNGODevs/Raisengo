@isTest
public with sharing class IntegrationLogCreator_Test {
    @isTest
    public static void testeLogCreation(){
        Test.startTest();
            new IntegrationLogCreator('Clockify-API', 'Delete', 'Teste Message', 'Ignored', 'Teste Body').publish();
        Test.stopTest();
        Integration_Log__c dbLog = [SELECT ID, Source__c, Endpoint_Type__c, Message__c, RequestBody__c, Result__c FROM Integration_Log__c];
        Assert.areEqual('Clockify-API', dbLog.Source__c, 'Wrong source value');
        Assert.areEqual('Delete', dbLog.Endpoint_Type__c, 'Wrong endpoint type value');
        Assert.areEqual('Teste Message', dbLog.Message__c, 'Wrong message value');
        Assert.areEqual('Ignored', dbLog.Result__c, 'Wrong result value');
        Assert.areEqual('Teste Body', dbLog.RequestBody__c, 'Wrong request body value');
    }
}