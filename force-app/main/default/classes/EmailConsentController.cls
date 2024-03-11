public class EmailConsentController {
		
    sObject objectToUpdate	{get;set;}
    CampaignMember member 	{get;set;}
    
    
    public EmailConsentController(){
		String encrypted_id = ApexPages.currentPage().getParameters().get('id');
        member = [SELECT id, Encrypted_Id__c, ContactId, LeadId, CampaignId, Status FROM CampaignMember WHERE Encrypted_Id__c =:encrypted_id];
        
        String sobjectType;
        String objectId;
        
        if(member.ContactId != null){
        	sobjectType = member.ContactId.getSObjectType().getDescribe().getName();
            objectId = member.ContactId;
        }else if(member.LeadId != null){
           	sobjectType = member.LeadId.getSObjectType().getDescribe().getName();
            objectId = member.LeadId; 
        } 
        
        String query = 'SELECT id, EmailConsent__c, Date_Last_Submitted_Consent__c FROM ' + sobjectType + ' WHERE id = :objectId';
		
        objectToUpdate = Database.query(query);      
    }
    
    public void updateValues(){
        objectToUpdate.put('EmailConsent__c', true);
        objectToUpdate.put('Date_Last_Submitted_Consent__c', System.today());        
        update objectToUpdate; 
        
        member.Status = 'Responded';
        member.Encrypted_Id__c = GeneralFunctions.encryptValue(objectToUpdate.id + '' + String.valueOf(System.currentTimeMillis()));
        update member;
    }
}