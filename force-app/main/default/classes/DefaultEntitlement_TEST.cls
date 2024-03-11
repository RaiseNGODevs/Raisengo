@isTest
public with sharing class DefaultEntitlement_TEST {
    @TestSetup
    static void makeData(){
        Account a = new Account();
        a.Name = 'Teste Account';
        insert a;

        Contact c = new Contact();
        c.FirstName = 'Teste';
        c.LastName = 'Contact';
        insert c;

        Case cas = new Case();
        cas.Origin = 'Email';
        insert cas;
    }
    @isTest
    static void searchByContact() {
        Contact cont = [SELECT ID FROM Contact LIMIT 1];
        Account acc = [SELECT ID FROM Account LIMIT 1];
        Case c = [SELECT ID FROM Case LIMIT 1];
        ServiceContract s = new ServiceContract();
        s.Name = 'Teste';
        s.ContactId = cont.ID;
        s.StartDate = Date.today().addDays(-1);
        s.EndDate = Date.today().addDays(1);
        insert s;
        Entitlement e = new Entitlement();
        e.Name = 'Teste';
        e.StartDate = Date.today().addDays(-1);
        e.EndDate = Date.today().addDays(1);
        e.AccountId = acc.ID;
        e.ServiceContractId = s.ID;
        insert e;
        Test.startTest();
            c.ContactId = cont.ID;
            update c;
        Test.stopTest();
        Case cas = [SELECT ID, Service_Contract__c, EntitlementId FROM Case LIMIT 1];
        Assert.areEqual(e.ID, cas.EntitlementId, 'Entitlement error');
        Assert.areEqual(s.ID, cas.Service_Contract__c, 'Service Contract error');
    }  
    @isTest
    static void searchByAccount() {
        Account a = [SELECT ID FROM Account LIMIT 1];
        Case c = [SELECT ID FROM Case LIMIT 1];
        ServiceContract s = new ServiceContract();
        s.Name = 'Teste';
        s.AccountId = a.ID;
        s.StartDate = Date.today().addDays(-1);
        s.EndDate = Date.today().addDays(1);
        insert s;
        Entitlement e = new Entitlement();
        e.Name = 'Teste';
        e.StartDate = Date.today().addDays(-1);
        e.EndDate = Date.today().addDays(1);
        e.AccountId = a.ID;
        e.ServiceContractId = s.ID;
        insert e;
        Test.startTest();
            c.AccountId = a.ID;
            update c;
        Test.stopTest();
        Case cas = [SELECT ID, Service_Contract__c, EntitlementId FROM Case LIMIT 1];
        Assert.areEqual(e.ID, cas.EntitlementId, 'Entitlement error');
        Assert.areEqual(s.ID, cas.Service_Contract__c, 'Service Contract error');
    }  
}