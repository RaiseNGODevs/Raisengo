public class EventQuestionnaire {
    public String questionPhotoAuthorization {get;set;}
    public String questionEventRelevance {get;set;}
    public String questionEventRecommendation {get;set;}
    public String questionSuggestions {get;set;}
    public Subscription__c subscription {get;set;}
    public Boolean submitted {get;set;}
    
    public EventQuestionnaire(){
        submitted = false;
        String subscriptionId = ApexPages.currentPage().getParameters().get('id');
        if(subscriptionId != null){
        	subscription = [SELECT id
                           FROM Subscription__c
                           WHERE id=:subscriptionId];    
        }
            
    }
    
    public void submit(){
        Event_Questionnaire__c questionnaire = new Event_Questionnaire__c();
        questionnaire.Subscription__c = subscription.id;
        questionnaire.Photo_Authorization__c = questionPhotoAuthorization;
        questionnaire.Event_Relevance__c = questionEventRelevance;
        questionnaire.Recommends_Event__c = questionEventRecommendation;
        questionnaire.Suggestions__c = questionSuggestions;
            
        insert questionnaire;
		submitted = true;
    }
}