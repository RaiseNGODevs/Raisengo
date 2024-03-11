public without sharing class CreateWeeklyAllocationButton {
    public TASKRAY__trContributor__c team { 
        get; 
        set;
    }
    
public CreateWeeklyAllocationButton (ApexPages.StandardController controller){
      
    	String tr_team = Apexpages.currentPage().getParameters().get('id');

       team = [SELECT Id, CreateWeeklyAllocations__c FROM TASKRAY__trContributor__c WHERE ID =: tr_team LIMIT 1]; 
      
}
    
        public PageReference UpdateCheckbox(){
        String PageID = ApexPages.currentPage().getParameters().get('id');
        team.CreateWeeklyAllocations__c = true; 
        update team; 
        PageReference pr = new PageReference('/'+PageID);
        pr.setRedirect(true);
        return pr; 
    }
}