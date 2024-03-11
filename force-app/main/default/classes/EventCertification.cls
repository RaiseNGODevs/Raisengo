public class EventCertification {
    public Subscription__c subscription {get;set;}
    public List<Subscription__c> listSubscription {get;set;}
    
    public EventCertification(){
        String eventId = ApexPages.currentPage().getParameters().get('event');
        if(eventId != null){
            listSubscription = new List<Subscription__c>();
        	listSubscription = [SELECT id, Contact__r.Name, Event_Form__r.Name, Event_Form__r.Venue__c, Event_Form__r.Event_Certification_Header__c, Event_Form__r.Event_Certification_Description__c, Event_Form__r.Start__c, Event_Form__r.End__c
                             FROM Subscription__c 
                             WHERE Event_Form__c=:eventId]; 
        }
        
        String subscriptionId = ApexPages.currentPage().getParameters().get('id');
        if(subscriptionId != null){
            try{
               subscription = [SELECT id, Contact__r.Name, Event_Form__r.Name, Event_Form__r.Venue__c, Event_Form__r.Event_Certification_Header__c, Event_Form__r.Event_Certification_Description__c, Event_Form__r.Start__c, Event_Form__r.End__c
                             FROM Subscription__c 
                             WHERE id=:subscriptionId]; 
            }catch(exception ex){
				ApexPages.addMessages(ex);
            }
             
        }
    }
    
}