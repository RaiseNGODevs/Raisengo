@isTest
public class CloseExpiredCases_TEST {
    @TestSetup
    static void makeData(){
        Case[] recordList = test.loadData(Case.sObjectType,'TestClassCases');
        /*
        List<Case> toInsert = new List<Case>();
        for (Integer i = 0; i < 5; i++) {
            toInsert.add(testFactory.createCase('Teste '+i, 'New'));
        }
        insert toInsert;*/
    }
    @isTest
    static void testBatch() {
        Test.startTest();
            Database.executeBatch(new CloseExpiredCases_Batch(), 200);
        Test.stopTest();
            List<Case> cas = [SELECT Id, Status, Resolution__c FROM Case WHERE Status = 'Closed'];
            Assert.areEqual(5, cas.size(), 'Nºao ficaram todos closed Size: '+cas.size());
            Assert.areEqual('Client Unavailable', cas[0].Resolution__c, 'Resolution errada '+cas[0].Resolution__c);
        
    }
    @isTest
    static void testSchedule() {
        String sch = '0 0 0 3 9 ? *';
        Test.startTest();
            String jobId = System.schedule('Merge Job', sch, new CloseExpiredCases_Batch());
        Test.stopTest();
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        Assert.areEqual(sch, ct.CronExpression, 'Nao agendou');
    }
}