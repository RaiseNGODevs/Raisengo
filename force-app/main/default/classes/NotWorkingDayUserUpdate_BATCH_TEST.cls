@isTest
public class NotWorkingDayUserUpdate_BATCH_TEST {
    
	@isTest
	public static void test_NotWorkingDayUserUpdate_BATCH(){
        Test.startTest();
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
            Start_Date__c=System.Today()-2,
            End_Date__c=System.Today()-1,
            Total_NWD__c=1,
			user__c=u.Id
        );
        
		insert nwd;
        
        Id batchJobId = Database.executeBatch(new NotWorkingDayUserUpdate_BATCH(), 25);       	
        System.assert(![SELECT ID FROM USER WHERE NWD_This_Year__c=1 LIMIT 1].isEmpty());
        
        delete nwd;
        
        Id batchJobId2 = Database.executeBatch(new NotWorkingDayUserUpdate_BATCH(), 25);       	
        System.assert(![SELECT ID FROM USER WHERE NWD_This_Year__c=0 LIMIT 1].isEmpty());
        
        Test.stopTest();
        
    }
    
    @isTest
	public static void test_SCHED(){
        SchedulableContext sc = null;
        NotWorkingDayUserUpdate_SCHED tsc = new NotWorkingDayUserUpdate_SCHED();
        tsc.execute(sc);
    }
}