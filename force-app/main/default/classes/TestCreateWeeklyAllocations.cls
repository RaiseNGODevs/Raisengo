@isTest

private class TestCreateWeeklyAllocations {
    @isTest static void TestCreateWeeklyAllocation(){
       
        
        TASKRAY__Project__c project = new TASKRAY__Project__c();
        project.Name = 'Test project';
        project.Contracted_Start_Date__c =  System.today();
        project.Contracted_End_Date__c = System.today().addDays(15);
        project.Contracted_Hours__c = 100; 
        project.Estimated_Hours__c = 50;
        
        insert project; 
        
        TASKRAY__trContributor__c tc = new TASKRAY__trContributor__c();
        
		User u = new user();        
        
		u.LastName = 'Test Code';
		u.Email = 'test@raisengo.pt';
		u.Alias = 'Tcode';
		u.Username = 'test@raisengo.pt';
		u.CommunityNickname = 'test';
		u.LocaleSidKey = 'en_US';
		u.TimeZoneSidKey = 'GMT';
		u.ProfileID = '00e58000000ammuAAA';
		u.LanguageLocaleKey = 'en_US';
		u.EmailEncodingKey = 'UTF-8';
		insert u;
        
      	tc.Name = 'Teste teste';
        tc.Start_Date__c = System.today();
        tc.End_Date__c = System.today().addDays(15);
        tc.Total_Hours_Estimated__c = 20; 
     	tc.TASKRAY__Project__c = project.Id;
        tc.TASKRAY__User__c = u.Id;
      	// tc.TASKRAY__GroupId__c = '123';

        
        insert tc;
        
        
        
    }
}