public class CustomSettings_CTRL {
    private static final String BATCH_NAME = 'Delete Logs Batch';
    @AuraEnabled(cacheable=true)
    public static ClockifySettings__c getCustomSettings() {
        return ClockifySettings__c.getInstance();
    }
    @AuraEnabled
    public static String setCustomSettings(Integer logsLifetime, String workspaceId, String updateKey, String stopKey, String deleteKey, String createKey) {
        List<ClockifySettings__c>  settingList = [SELECT ID FROM ClockifySettings__c];
        ClockifySettings__c setting;
        if(settingList.isEmpty()) {
            setting = new ClockifySettings__c();
            insert setting;
        }else {
            setting = settingList[0];
        }
        if(!validator(logsLifetime, workspaceId, updateKey, stopKey, deleteKey, createKey)){
            return 'You missed some fields!';
        }
        setting.Signing_Create_Key__c = createKey;
        setting.Signing_Delete_Key__c = deleteKey;
        setting.Signing_Stop_Key__c  = stopKey;
        setting.Signing_Update_Key__c = updateKey;
        setting.workspaceId__c  = workspaceId;
        setting.LogsLifeTime__c = logsLifetime;
        update setting;
        scheduleJob();
        return 'API Configuration successfully saved!';
    }
    
    private static Boolean validator(Integer logsLifetime, String workspaceId, String updateKey, String stopKey, String deleteKey, String createKey) {
        if(logsLifetime<=0 || 
            String.isBlank(workspaceId) || 
                String.isBlank(updateKey) || 
                    String.isBlank(stopKey)|| 
                        String.isBlank(deleteKey) || 
                            String.isBlank(createKey)) {
            return false;
        }
        return true;
    }
    private static void scheduleJob() {
        if(!existsJob()) {
            System.schedule(BATCH_NAME, '0 0 4 ? * SUN *', new DeleteLogs_Batch());
        }
    }
    
    private static Boolean existsJob() {
        List<CronTrigger> jobRecords = [SELECT Id FROM CronTrigger  where CronJobDetail.Name =: BATCH_NAME];
        if(jobRecords.isEmpty()){
            return false;
        }
        return true;
    }
}