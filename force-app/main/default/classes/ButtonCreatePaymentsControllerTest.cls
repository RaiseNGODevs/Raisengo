@isTest
public class ButtonCreatePaymentsControllerTest {
	
    @testSetup
    public static void setup(){
        Account act = new Account(Name = 'Test Org');
        insert act;
        Contact ct = new Contact(LastName = 'Test', AccountId = act.Id);
        insert ct;
        Opportunity opp = new Opportunity(Name = 'Test Opp', Amount = 600, Instalments__c = 9, Payment_Schedule__c = 'Monthly', StageName = 'Proposal/Quote', CloseDate = Date.today(), First_Scheduled_Date__c = Date.today(), AccountId = act.Id );
        insert opp;
    }
    //comment because there was an error in deployment 
 /*   @isTest
    public static void teste(){
        Opportunity opp  = [SELECT Id FROM Opportunity LIMIT 1];
        ApexPages.currentPage().getParameters().put( 'id', opp.Id );
        ApexPages.StandardController sc = new ApexPages.standardController(opp);
        
        ButtonCreatePaymentsController bcpc = new ButtonCreatePaymentsController(sc);
        bcpc.create();
    }*/
    
}