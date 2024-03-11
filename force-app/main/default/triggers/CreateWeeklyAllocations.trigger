trigger CreateWeeklyAllocations on TASKRAY__trContributor__c (after insert, after update) {
    Decimal Number_of_Mondays{get; set;}
    Decimal Hours_per_week {get;set;}
    Date Start_Date {get;set;}
    Id taskray_team {get; set;}
    Id taskray_project {get; set;}
    Boolean createWeeklyAlloc {get;set;}
    List<Team_Weekly_Allocation__c > allocations = new List<Team_Weekly_Allocation__c>(); 
    List<TASKRAY__trContributor__c> teams = [SELECT Id, TASKRAY__Project__c, Hours_per_Week__c, Start_Date__c, Number_of_Mondays__c, CreateWeeklyAllocations__c  FROM TASKRAY__trContributor__c WHERE Id IN: Trigger.newMap.keySet() LIMIT 1];
     
  
    if(teams.size()>0){
        
        for(TASKRAY__trContributor__c tc : teams){
            Number_of_Mondays = tc.Number_of_Mondays__c; 
            Hours_per_week = tc.Hours_per_Week__c;
            Start_Date = tc.Start_Date__c; 
            taskray_team = tc.Id;
            taskray_project = tc.TASKRAY__Project__c;
            createWeeklyAlloc = tc.CreateWeeklyAllocations__c;
        }
       
    }  
    
    if(createWeeklyAlloc){ 
        if(Number_of_Mondays > 0){
            
            Integer aux = 0; 
            for (Integer i = 0; i < Number_of_Mondays ; i ++){
                Team_Weekly_Allocation__c  weekly_alloc = new Team_Weekly_Allocation__c();
                weekly_alloc.TaskRay_Team__c = taskray_team; 
                weekly_alloc.Date__c = Start_Date.addDays(aux);
                weekly_alloc.Estimated_Hours__c = Hours_per_week; 
                weekly_alloc.TaskRay_Project__c = taskray_project; 
                aux = aux + 7; 
                allocations.add(weekly_alloc);
                
            }
            

            
        }
        
                 try {
                     teams[0].CreateWeeklyAllocations__c = false; 
                     update teams;
       			  upsert allocations;
        } catch (DmlException e) {
            System.debug('Exception' + e);
   }
       
}
    

  
    
    
        
}