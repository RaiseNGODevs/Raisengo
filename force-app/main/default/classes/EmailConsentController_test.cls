@isTest
public class EmailConsentController_test {
	@isTest
    public static void testContact(){
        Contact cont = new Contact(FirstName='First', lastName='Lastn');
        insert cont;
        
        Campaign camp = new Campaign(name='consentimento');
        insert camp;
        
        CampaignMember member = new CampaignMember(ContactId = cont.id, CampaignId = camp.id);
        insert member;        
        
        ApexPages.currentPage().getParameters().put('id', [SELECT Encrypted_Id__c FROM CampaignMember WHERE id = :member.id][0].Encrypted_id__c);
        EmailConsentController controller = new EmailConsentController();
        controller.updateValues();

        Contact updatedC = [SELECT EmailConsent__c FROM Contact WHERE id =: cont.id];
		System.assertEquals(true, updatedC.EmailConsent__c);        
    }
    
    @isTest
    public static void testLead(){
        Lead l = new Lead(FirstName='First', lastName='Last', Company='RaiseN\'GO');
        insert l;
        
		Campaign camp = new Campaign(name='consentimento');
        insert camp;
        
        CampaignMember member = new CampaignMember(LeadId = l.id, CampaignId = camp.id);
        insert member;
        
        ApexPages.currentPage().getParameters().put('id', [SELECT Encrypted_Id__c FROM CampaignMember WHERE id = :member.id][0].Encrypted_id__c);
        
        EmailConsentController controller = new EmailConsentController();
        controller.updateValues();

        Lead updatedL = [SELECT EmailConsent__c FROM Lead WHERE id=:l.id];
		System.assertEquals(true, updatedL.EmailConsent__c);        
    }
}