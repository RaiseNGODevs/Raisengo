public with sharing class EventConfirmationController {
    
    public string idSubscription {get;set;}
    public Subscription__c subscription;
    public String message {get;set;}
    public boolean resultado {get;set;}
    
    public EventConfirmationController(){
        
    }
    
    public void checkLink(){
        resultado = false;
        message = 'Não foi possível confirmar a presença deste participante.';
        subscription = new Subscription__c();
        idSubscription = ApexPages.currentPage().getParameters().get('subscription');   
      
        try {
            subscription = [SELECT ID,Presen_a_no_Evento__c,Event_Form__c,Contact__c 
                                 FROM Subscription__c 
                                 WHERE  Id=:idSubscription];
            getsomeProperty();  
        }catch(exception ex) {
            System.debug('Ocorreu uma excepção::::::: '+ex);
        }
        
    }
    
    public boolean checkSubscription(Subscription__c  subscription) {
        boolean res = false;
        try {
         
            if (subscription.Presen_a_no_Evento__c != 'Presente') {
           
                subscription.Presen_a_no_Evento__c = 'Presente';
                update subscription;
                res = true;
                message = 'Presença confirmada! A informação foi atualizada no Salesforce.';
            }else if (subscription.Presen_a_no_Evento__c == 'Presente'){
                message = 'A presença deste participante já foi confirmada anteriormente.';
            }
            
        }catch(exception ex){
            System.debug('Ocorreu uma excepção::::::: '+ex);
        }           
        return res;
    }
    
   
    
    public String getsomeProperty() {
        if(subscription!=null && subscription.id!=null){
            resultado = checkSubscription(subscription);
        }
        
        return null;
    }
    
}