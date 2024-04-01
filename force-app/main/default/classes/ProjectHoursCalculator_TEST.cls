@isTest
public class ProjectHoursCalculator_TEST {
    @TestSetup
    static void makeData(){
        Account a = new Account();
        a.Name = 'Teste Client';
        insert a;

        ServiceContract sContract = testFactory.createServiceContract('Teste', a.Id, '');
        sContract.TotalHoursPerContract__c = 8;
        sContract.MonthlyHoursPerContract__c = 5;
        insert sContract;
        List<TimeEntry__c> entries = new List<TimeEntry__c>();
        for(Integer i = 0; i<5; i++){
            entries.add(testFactory.createTimeEntry(String.valueOf(i), null, 'Teste', Datetime.now(), Datetime.now().addHours(1), sContract.Id));
        }
        insert entries;
    }
    @isTest
    static void testBatch() {
        Test.startTest();
            Database.executeBatch(new ProjectHoursCalculator_Batch(), 1);
        Test.stopTest();
            ServiceContract sC = [SELECT Id, RemainingTotalHours__c, RemainingMonthlyHours__c FROM ServiceContract LIMIT 1];
            Assert.areEqual(3, sC.RemainingTotalHours__c, 'Total Hours Falhou: '+sC.RemainingTotalHours__c);
            Assert.areEqual(0, sC.RemainingMonthlyHours__c, 'Monthly Hours Falhou: '+sC.RemainingMonthlyHours__c);
        
    }
    @isTest
    static void testSchedule() {
        String sch = '0 0 0 3 9 ? *';
        Test.startTest();
            String jobId = System.schedule('Merge Job', sch, new ProjectHoursCalculator_Batch());
        Test.stopTest();
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        Assert.areEqual(sch, ct.CronExpression, 'Nao agendou');
    }
}