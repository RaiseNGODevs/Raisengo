public class NotWorkingDayTriggerHandler {
    
    public static void onBeforeInsert(List<SObject> newList){
		//calculateTotaNWD(newList);
    }

    public static void onBeforeUpdate(List<Not_Working_Days__c> newList, List<Not_Working_Days__c> oldList){
        //calculateTotaNWD(newList);
    }

    public static void onAfterUpdate(List<Not_Working_Days__c> newList, List<Not_Working_Days__c> oldList){
    	updateUserNWD(newList);    	
    }
    
    public static void onAfterInsert(List<Not_Working_Days__c> newList, List<Not_Working_Days__c> oldList){
		updateUserNWD(newList);
    }
    
    public static void onAfterDelete(List<Not_Working_Days__c> oldList){
		updateUserNWD(oldList);
    }
    
    public static void updateUserNWD(List<Not_Working_Days__c> wlist){
        List <User> usersToUpdate = new list <user>();
        
        for(Not_Working_Days__c nwd : wlist){    
            if (nwd.user__c!=null){
                usersToUpdate.add(new user(id= nwd.User__c));
            }
        }
        
        List <AggregateResult> list_notWorkingDaysSUM = [select user__c, SUM(Total_NWD__c)total from Not_Working_Days__c where Start_Date__c=THIS_YEAR and End_Date__c=THIS_YEAR and Start_Date__c<TODAY and End_Date__c<TODAY and user__c in:usersToUpdate group by user__c ];
		
        if(list_notWorkingDaysSUM.isEmpty()){
            for(User u : usersToUpdate){
                u.NWD_This_Year__c=0;
            }    
        }
        
        else{
        	usersToUpdate.clear();
            for(AggregateResult user_nwdSUM : list_notWorkingDaysSUM){
                User u = new user();
                u.id= (Id) user_nwdSUM.get('user__c');
                u.NWD_This_Year__c = (decimal) user_nwdSUM.get('total');
                usersToUpdate.add(u);    
            }    
        }
            
        if(!usersToUpdate.isEmpty()) update usersToUpdate;       
    }
    /*
    public static void calculateTotaNWD(List<Not_Working_Days__c> newList){
        
        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE IsDefault=true];
        
    	for( Not_Working_Days__c  nwd : newList ){
            if(nwd.Start_Date__c!=null && nwd.End_Date__c!=null){
                nwd.Total_NWD__c=BusinessHours.diff(bh.id, nwd.Start_Date__c, nwd.End_Date__c)/3600000/8;
            }
        }     
    }*/

}