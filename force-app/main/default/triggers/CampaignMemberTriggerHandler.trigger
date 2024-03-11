trigger CampaignMemberTriggerHandler on CampaignMember (after insert, after update) {
    
    List<CampaignMember> listMembers = [SELECT Encrypted_Id__c FROM CampaignMember WHERE Id IN: Trigger.newMap.keySet()];
        
    for( CampaignMember c : listMembers ){
        if(c.Encrypted_Id__c == null || c.Encrypted_Id__c == ''){
        	c.Encrypted_Id__c = GeneralFunctions.encryptValue(c.Id + '' + String.valueOf(System.currentTimeMillis()));      
        }
    }
    
    System.debug('entrou');
    System.debug(listMembers);
        
    if(!checkTriggerRecursive.isTriggerRunning){
	    checkTriggerRecursive.isTriggerRunning = true;
        update listMembers;
    }
    
}