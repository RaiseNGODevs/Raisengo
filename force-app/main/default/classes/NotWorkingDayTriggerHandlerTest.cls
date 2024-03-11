@isTest
public class NotWorkingDayTriggerHandlerTest {
	
	@isTest
    public static void test1(){
        
        User u = new User(
            LastName = 'Test',
			Email = 'test@raisengo.pt',
			Alias = 'test',
			Username = 'test@raisengo.pt',
			CommunityNickname = 'test',
			LocaleSidKey = 'en_US',
			TimeZoneSidKey = 'GMT',
			ProfileID = '00e58000000ammuAAA',
			LanguageLocaleKey = 'en_US',
			EmailEncodingKey = 'UTF-8'
        );
        
        insert u;
        
        Not_Working_Days__c nwd = new Not_Working_Days__c(
            Start_Date__c=System.Today(),
            End_Date__c=System.Today()+1,
			user__c=u.Id
        );
        
        Test.startTest();
        insert nwd;
        update nwd;
        delete nwd;
        Test.stopTest();
        
    }

}