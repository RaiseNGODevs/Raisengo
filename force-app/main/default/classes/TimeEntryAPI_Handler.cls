public class TimeEntryAPI_Handler {
    public static void createAPI(RestRequest req){
        TimeEntryWrapper timeEntry = TimeEntryWrapper.parse(req.requestBody.toString());
        if(!validateEntry(timeEntry)){
            new IntegrationLogCreator('Clockify-API', 'Create-Manually', 'Time Entry failed Validation', 'Ignored', Json.serialize(timeEntry)).publish();
            return;
        }
        retrieveObjects(timeEntry, new TimeEntry__c());
    }
    public static void updateAPI(RestRequest req){
        TimeEntryWrapper timeEntry = TimeEntryWrapper.parse(req.requestBody.toString());
        if(!validateEntry(timeEntry)){
            new IntegrationLogCreator('Clockify-API', 'Update', 'Time Entry failed Validation', 'Ignored', Json.serialize(timeEntry)).publish();
            return;
        }
        List<TimeEntry__c> databaseEntry = new List<TimeEntry__c>();
        databaseEntry.addAll([SELECT ID, ClockifyTimeEntryId__c, StartTime__c, EndTime__c, Description__c, UserId__c, CaseId__c
                                 FROM TimeEntry__c WHERE ClockifyTimeEntryId__c=:timeEntry.id LIMIT 1]);
        if(!databaseEntry.isEmpty()){
            retrieveObjects(timeEntry, databaseEntry[0]);
        }else{
            retrieveObjects(timeEntry, new TimeEntry__c());
        }
    }
    public static void deleteAPI(RestRequest req){
        TimeEntryWrapper timeEntry = TimeEntryWrapper.parse(req.requestBody.toString());
        List<TimeEntry__c> databaseEntry = new List<TimeEntry__c>();
        databaseEntry.addAll([SELECT ID FROM TimeEntry__c WHERE ClockifyTimeEntryId__c=:timeEntry.id LIMIT 1]);
        if(!databaseEntry.isEmpty()){
            delete databaseEntry[0];
        }else{
            new IntegrationLogCreator('Clockify-API', 'Delete', 'Time Entry not found in database', 'Ignored', Json.serialize(timeEntry)).publish();
        }
    }
    private static Boolean validateEntry(TimeEntryWrapper timeEntry){
        if(String.isBlank(timeEntry.projectId) || 
            String.isBlank(timeEntry.workspaceId) || 
                String.isBlank(timeEntry.userId)){
                    return false;
        }
        return true;
    }
    private static void retrieveObjects(TimeEntryWrapper timeEntry, TimeEntry__c entry){
        List<User> entryUser = new List<User>();
        entryUser.addAll([SELECT ID FROM User WHERE ClockifyUserId__c =:timeEntry.userId LIMIT 1]);
        List<ServiceContract> entryProject = new List<ServiceContract>();
        entryProject.addAll([SELECT ID FROM ServiceContract WHERE ClockifyProjectId__c=:timeEntry.projectId LIMIT 1]);
        if(entryUser.isEmpty() || entryProject.isEmpty()){
            new IntegrationLogCreator('Clockify-API', 'Retrieve-Objects', 'Project or User not found', 'Ignored', Json.serialize(timeEntry)).publish();
            return;
        }
        if(timeEntry.task != null){
            List<Case> entryTask = new List<Case>();
            entryTask.addAll([SELECT ID, EntitlementId FROM Case WHERE Clockify_Task_Id__c=:timeEntry.task.id LIMIT 1]);
            ID task = entryTask.isEmpty() ? null : entryTask[0].ID;
            upsertEntry(entryUser[0], entryProject[0], task, timeEntry, entry);
        }else{
            upsertEntry(entryUser[0], entryProject[0], timeEntry, entry);
        }
    }
    private static void upsertEntry(User entryUser, ServiceContract entryProject, ID entryTask, TimeEntryWrapper timeEntry, TimeEntry__c entry){    
        entry.CaseId__c = entryTask;
        upsertEntry(entryUser, entryProject, timeEntry, entry);
    }
    private static void upsertEntry(User entryUser, ServiceContract entryProject, TimeEntryWrapper timeEntry, TimeEntry__c entry){
        entry.ClockifyTimeEntryId__c = timeEntry.id;
        entry.StartTime__c = getZuluDate(timeEntry.timeInterval.start);
        entry.EndTime__c = getZuluDate(timeEntry.timeInterval.end_x);
        entry.Description__c = timeEntry.description;
        entry.isBillable__c = timeEntry.billable;
        entry.UserId__c = entryUser.ID;
        entry.Service_Contract__c = entryProject.ID;
        upsert entry;
    }
    private static Datetime getZuluDate(String zulu) {
        Datetime d = Datetime.valueOf(zulu.replace('T',' '));
        return d;
    }
}