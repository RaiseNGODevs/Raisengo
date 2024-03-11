public class NotWorkingDayUserUpdate_BATCH implements Database.Batchable<sObject>, Database.Stateful{

    public Integer recordsProcessed = 0;  
    public Database.QueryLocator start(Database.BatchableContext bc) {
        List<ID> user_profile_list = new List <ID>();
        user_profile_list.add('00e58000000ammuAAA'); //System Administrator
        user_profile_list.add('00e58000000hgW8AAI'); //Team
        user_profile_list.add('00e8d000000pEN1AAM'); //Project Manager
        user_profile_list.add('00e8d000000pWqxAAE'); //Hour Project Manager
        user_profile_list.add('00e58000000hg7NAAQ'); //Administrator (Raise N'GO)
        return Database.getQueryLocator('SELECT Id FROM USER WHERE profileId in:user_profile_list and IsActive=true');
    }
    
    public void execute(Database.BatchableContext bc, List<User> scope){
    	List <AggregateResult> list_notWorkingDaysSUM = [select user__c, SUM(Total_NWD__c)total from Not_Working_Days__c where Start_Date__c=THIS_YEAR and End_Date__c=THIS_YEAR and Start_Date__c<TODAY and End_Date__c<TODAY and user__c in:scope group by user__c ];
		
    	if(list_notWorkingDaysSUM.isEmpty()){
       		for(User u : scope){
        		u.NWD_This_Year__c=0;
            }    
        }
        
        else{
        	scope.clear();
            for(AggregateResult user_nwdSUM : list_notWorkingDaysSUM){
                User u = new user( id= (Id) user_nwdSUM.get('user__c'),NWD_This_Year__c = (decimal) user_nwdSUM.get('total') );
                scope.add(u);    
            }    
        }
            
        if(!scope.isEmpty()) update scope;
    }
    
    public void finish(Database.BatchableContext bc){        
        System.debug('Debug Update_Status_Prescricao_BATCH: '+ recordsProcessed + ' records processed.');
    }

}