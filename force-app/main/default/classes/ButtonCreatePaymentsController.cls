public with sharing class ButtonCreatePaymentsController {
    
    public Opportunity opp;

    public ButtonCreatePaymentsController(ApexPages.StandardController controller) {
       opp = (Opportunity)controller.getRecord();
    }
    
    public PageReference create(){
        List<Payment__c> listPayments = new List<Payment__c>();
        
        Date nextPaymentDate;
        Integer nPayments, dateIncrement;
        Opportunity opp = [SELECT id, Amount, AccountId, Payment_Schedule__c, Instalments__c, First_Scheduled_Date__c 
                           FROM Opportunity 
                           WHERE id=: opp.id];
        nextPaymentDate = opp.First_Scheduled_Date__c;
        
        if(opp.Payment_Schedule__c == 'Monthly'){
        	dateIncrement = 1;
        }
        else if(opp.Payment_Schedule__c == 'Quarterly'){
        	dateIncrement = 3;
        }
        else if(opp.Payment_Schedule__c == 'Once'){
            dateIncrement = 0;
        }
        else{
            dateIncrement = null;	//Para gerar um erro
        }
        
        for( Integer i = 0; i < opp.Instalments__c; i++ ){
            listPayments.add( new Payment__c( Payment_Amount__c = ( opp.Amount / opp.Instalments__c ), 
                                             Scheduled_Date__c = nextPaymentDate,
                                             Stage__c = 'Pledged',
                                             Account__c = opp.AccountId,
                                             Opportunity__c = opp.Id) );
            
            nextPaymentDate = nextPaymentDate.addMonths( dateIncrement );
        }
        
        Database.insert(listPayments);
        
        PageReference pageRef = new PageReference('/'+opp.id);
        return pageRef;
    }
}