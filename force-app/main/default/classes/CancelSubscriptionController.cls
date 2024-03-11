global class CancelSubscriptionController {
    global Subscription__c subscription		{get;set;}
    
    global CancelSubscriptionController(){        
        String subscriptionID = ApexPages.currentPage().getParameters().get('id');
        
        if(subscriptionID != '' && subscriptionID != null){
            try{
                subscription = [select Status__c from Subscription__c where id =: subscriptionID];
            }catch(exception e){
                System.debug(e);
            }
        }
    }
    global void updateSubscription(){
        subscription.Status__c= 'Cancelada';
        update subscription;
    }
}