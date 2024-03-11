public class TaskrayTimeTriggerHandler {
    
    public static void onBeforeInsert(List<SObject> newList){
        setTaskrayTeam((List<TASKRAY__trTaskTime__c>) newList);
    }
   
    public static void onBeforeUpdate(List<SObject> newList, List<SObject> oldList){
        setTaskrayTeam(newList);
    }
    
    private static void setTaskrayTeam(List<TASKRAY__trTaskTime__c> newList){
        Map<Object, List<SObject>> newTimesByProject = GeneralFunctions.groupSObjectByField(newList, 'TASKRAY__Project__c');
        Set<Id> projectIds = new Set<Id>();
        for( Object obj : newTimesByProject.keySet() )
            projectIds.add((Id) obj);
        
        List<TASKRAY__trContributor__c> taskrayTeams = [SELECT Id, TASKRAY__Project__c, TASKRAY__User__c
                                                        FROM TASKRAY__trContributor__c
                                                        WHERE TASKRAY__Project__c IN :projectIds];
        Map<Object, List<SObject>> taskrayTeamsByProject = GeneralFunctions.groupSObjectByField(taskrayTeams, 'TASKRAY__Project__c');
        
        for( TASKRAY__trTaskTime__c taskTime : newList ){
            if( String.isNotBlank(taskTime.TASKRAY__Project__c) && String.isBlank(taskTime.TaskRay_Team__c) ){
                List<TASKRAY__trContributor__c> projectTeams = (List<TASKRAY__trContributor__c>) taskrayTeamsByProject.get(taskTime.TASKRAY__Project__c);
                for(TASKRAY__trContributor__c taskrayTeam : projectTeams){
                    if( taskrayTeam.TASKRAY__User__c == taskTime.TASKRAY__Owner__c ){
                        taskTime.TaskRay_Team__c = taskrayTeam.Id;
                        break;
                    }
                }
            }
        }
    }
}