/****************************************************************************************************************
 * 06-03-2022 - Luís Branquinho - First reply implementation
 * 03-03-2022 - Luís Branquinho - uncomment setCloseDate | Solve bug Time_spent__c
 * 12-05-2022 - Luís Branquinho - Added setCloseDate/setServiceLevel/ Expected_SL__c  							*
 * 14-07-2022 - Luís Branquinho - Add BusinessHours counter for status Waiting for Someone						* 
 * 14-07-2022 - Luís Branquinho - setCloseDate Commented - Only usefull if task is closed right after solved	*								
 * **************************************************************************************************************/


public class TaskrayTaskTriggerHandler {

    static final BusinessHours bh = [SELECT Id FROM BusinessHours WHERE IsDefault=true]; 

    public static void onBeforeInsert(List<SObject> newList){
        setTaskrayTeam((List<TASKRAY__Project_Task__c>) newList, null);
    }
   
    public static void onBeforeUpdate(List<SObject> newList, List<SObject> oldList){
        setTaskrayTeam(newList, new Map<Id, SObject>(oldList));
        setWaitingforSomeoneCounter(newList, new Map<Id, SObject>(oldList));
        setServiceLevel(newList, new Map<Id, SObject>(oldList));
        setDeadline(newList);
        setCloseDate(newList,new Map<Id, SObject>(oldList));
        setTimeSpend(newList,new Map<Id, SObject>(oldList));
        setFirstReply(newList,new Map<Id, SObject>(oldList));
    }
	    
    public static void setFirstReply(List<TASKRAY__Project_Task__c> newList, Map<Id, SObject> oldMap){		
		     
    	for( TASKRAY__Project_Task__c task : newList ){
            
            TASKRAY__Project_Task__c oldTask = (TASKRAY__Project_Task__c) oldMap.get(task.Id);
            
            if(task.Task_Type__c=='Support' && 
               task.TASKRAY__List__c=='Done' &&
               (task.First_Reply__c!=null)
              ){
                
                datetime initialdate = task.CreatedDate!=null ? task.CreatedDate : system.now();
                task.Time_spent_first_reply__c=Decimal.valueOf(BusinessHours.diff(bh.id, initialdate, task.First_Reply__c))/3600000 ;
 
            }
        }    	

    }   
    
    public static void setWaitingforSomeoneCounter(List<TASKRAY__Project_Task__c> newList, Map<Id, SObject> oldMap){
		
        TASKRAY__Project_Task__c oldTask;

        for( TASKRAY__Project_Task__c task : newList ){      
        	if(task.TASKRAY__List__c=='Waiting for someone'){
            	if(task.Initial_Waiting_for_Someone_Date__c==null || oldMap==null){
            		task.Initial_Waiting_for_Someone_Date__c=system.now();
            	}    
            }

            else if(oldMap!=null){
            	oldTask = (TASKRAY__Project_Task__c) oldMap.get(task.Id);
                if(oldTask.TASKRAY__List__c=='Waiting for someone'){
                    task.Time_Paused__c = task.Time_Paused__c==null ? 0 : task.Time_Paused__c;
                    task.Time_Paused__c+=Decimal.valueOf(BusinessHours.diff(bh.id, task.Initial_Waiting_for_Someone_Date__c, system.now()))/3600000;              
                	task.Initial_Waiting_for_Someone_Date__c=null;   
                }
            }
  
        }
    }    
    
    public static void setCloseDate(List<TASKRAY__Project_Task__c> newList, Map<Id, SObject> oldMap){
        for( TASKRAY__Project_Task__c task : newList ){
            TASKRAY__Project_Task__c oldTask = (TASKRAY__Project_Task__c) oldMap.get(task.Id);
            if(!oldTask.TASKRAY__trCompleted__c && task.TASKRAY__trCompleted__c && task.Close_Date__c==null){
                task.Close_Date__c = system.now();
            }
        }

    }
    
    public static void setServiceLevel(List<TASKRAY__Project_Task__c> newList, Map<Id, SObject> oldMap){
    	for( TASKRAY__Project_Task__c task : newList ){

			boolean Initial_SL = (task.SLA__c==null) ? true : false;  
            
           	TASKRAY__Project_Task__c oldTask;
            if(oldMap != null) {
                	oldTask = (TASKRAY__Project_Task__c) oldMap.get(task.Id);
            }
            
            if(oldTask.Impact_Level__c!=task.Impact_Level__c){    
                switch on task.Impact_Level__c {
                        
                    when 'High' {
                        task.SLA__c='SL1';
                        //task.Time_Until_Estimation=Decimal.valueOf(BusinessHours.diff(bh.id, initialdate, task.Close_Date__c))/3600000 
                    }	
                    when 'Moderate' {
                        task.SLA__c='SL2';
                    }
                    when 'Low' {
                        task.SLA__c='SL3';
                    }
                    when else {		  
                        task.SLA__c=null;
                    }
                }
            	task.Expected_SL__c=task.SLA__c;    
            }
        }       
	}
    
    private static void setTaskrayTeam(List<TASKRAY__Project_Task__c> newList, Map<Id, SObject> oldMap){
        Map<Object, List<SObject>> newTimesByProject = GeneralFunctions.groupSObjectByField(newList, 'TASKRAY__Project__c');
        Set<Id> projectIds = new Set<Id>();
        for( Object obj : newTimesByProject.keySet() )
            projectIds.add((Id) obj);
        
        List<TASKRAY__trContributor__c> taskrayTeams = [SELECT Id, TASKRAY__Project__c, TASKRAY__User__c
                                                        FROM TASKRAY__trContributor__c
                                                        WHERE TASKRAY__Project__c IN :projectIds];
        Map<Object, List<SObject>> taskrayTeamsByProject = GeneralFunctions.groupSObjectByField(taskrayTeams, 'TASKRAY__Project__c');
        
        for( TASKRAY__Project_Task__c task : newList ){
            TASKRAY__Project_Task__c oldTask;
            if(oldMap != null) {
                	oldTask = (TASKRAY__Project_Task__c) oldMap.get(task.Id);
            }
            if( String.isNotBlank(task.TASKRAY__Project__c) && String.isBlank(task.TaskRay_Team__c) &&
              	(oldTask == null || oldTask.Task_Owner_User__c  != task.Task_Owner_User__c )){
                List<TASKRAY__trContributor__c> projectTeams = (List<TASKRAY__trContributor__c>) taskrayTeamsByProject.get(task.TASKRAY__Project__c);
                for(TASKRAY__trContributor__c taskrayTeam : projectTeams){
                    if( taskrayTeam.TASKRAY__User__c == task.Task_Owner_User__c  ){
                        task.TaskRay_Team__c = taskrayTeam.Id;
                        break;
                    }
                }
            }
        }
    }
    
    public static void setTimeSpend(List<TASKRAY__Project_Task__c> newList,Map<Id, SObject> oldMap){
      
    	for( TASKRAY__Project_Task__c task : newList ){
            
            TASKRAY__Project_Task__c oldTask = (TASKRAY__Project_Task__c) oldMap.get(task.Id);
            
            if(task.Task_Type__c=='Support' && 
               task.TASKRAY__List__c=='Done' &&
               (task.Close_Date__c!=null)
              ){
                
                datetime initialdate = task.CreatedDate!=null ? task.CreatedDate : system.now();
                task.Time_spent__c=Decimal.valueOf(BusinessHours.diff(bh.id, initialdate, task.Close_Date__c))/3600000 ;
                
                if(task.Time_Paused__c!=null){
                	task.Time_spent__c=task.Time_spent__c-task.Time_Paused__c;       
                }
				 
            }
        }    
    }
    
    public static void setDeadline(List<TASKRAY__Project_Task__c> newList){
             
    	for( TASKRAY__Project_Task__c task : newList ){
            if(task.Task_Type__c=='Support' && task.SLA__c!=null){
                
                datetime initialdate = task.CreatedDate!=null ? task.CreatedDate : system.now();
                
                switch on task.SLA__c {
                    when 'SL1' {
						//16h		
                        task.Deadline_to_solve__c=BusinessHours.add(bh.id,initialdate,57600000);
                    }	
                    when 'SL2' {
                        //24h
                        task.Deadline_to_solve__c=BusinessHours.add(bh.id,initialdate,86400000);
                    }
                    when 'SL3' {
						//40h	
                        task.Deadline_to_solve__c=BusinessHours.add(bh.id,initialdate,144000000);
                    }
                    when else {		  
                        task.Deadline_to_solve__c=null;
                    }
				}
                
            }
        }    
    }
    
}