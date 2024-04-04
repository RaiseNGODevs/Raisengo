public class CustomSettings_CTRL {
    private static final String LOGS_BATCH_NAME = 'DeleteLogs_Batch';
    private static final String HOURS_BATCH_NAME = 'ProjectHoursCalculator_Batch';
    private static final String CLOSED_BATCH_NAME = 'CloseExpiredCases_Batch';
    private static final String logsCron = '0 0 4 ? * SUN *';
    private static final String hoursCron = '0 0 23 1/1 * ? *';
    private static final String closeCron = '0 45 23 1/1 * ? *';

    @AuraEnabled(cacheable=true)
    public static ClockifySettings__c getCustomSettings() {
        return ClockifySettings__c.getInstance();
    }
    @AuraEnabled
    public static String setCustomSettings(Integer logsLifetime, Integer closeTime, String workspaceId, String updateKey, String stopKey, String deleteKey, String createKey) {
        List<ClockifySettings__c>  settingList = [SELECT ID FROM ClockifySettings__c];
        ClockifySettings__c setting;
        if(settingList.isEmpty()) {
            setting = new ClockifySettings__c();
            insert setting;
        }else {
            setting = settingList[0];
        }
        if(!validator(logsLifetime, closeTime, workspaceId, updateKey, stopKey, deleteKey, createKey)){
            return 'You missed some fields!';
        }
        setting.Signing_Create_Key__c = createKey;
        setting.Signing_Delete_Key__c = deleteKey;
        setting.Signing_Stop_Key__c  = stopKey;
        setting.Signing_Update_Key__c = updateKey;
        setting.workspaceId__c  = workspaceId;
        setting.LogsLifeTime__c = logsLifetime;
        setting.autoCloseDays__c = closeTime;
        update setting;
        scheduleLogsJob();
        scheduleHoursJob();
        scheduleCloseJob();
        return 'API Configuration successfully saved!';
    }
    
    private static Boolean validator(Integer logsLifetime, Integer closeTime, String workspaceId, String updateKey, String stopKey, String deleteKey, String createKey) {
        if(logsLifetime<=0 ||
            closeTime <=0 ||
                String.isBlank(workspaceId) || 
                    String.isBlank(updateKey) || 
                        String.isBlank(stopKey)|| 
                            String.isBlank(deleteKey) || 
                                String.isBlank(createKey) ) {
            return false;
        }
        return true;
    }
    private static void scheduleLogsJob() {
        if(!existsJob(LOGS_BATCH_NAME)) {
            System.schedule(LOGS_BATCH_NAME, logsCron, new DeleteLogs_Batch());
        }
    }

    private static void scheduleHoursJob() {
        if(!existsJob(HOURS_BATCH_NAME)) {
            System.schedule(HOURS_BATCH_NAME, hoursCron, new ProjectHoursCalculator_Batch());
        }
    }

    private static void scheduleCloseJob() {
        if(!existsJob(CLOSED_BATCH_NAME)) {
            System.schedule(CLOSED_BATCH_NAME, closeCron, new CloseExpiredCases_Batch());
        }
    }
    
    private static Boolean existsJob(String jobName) {
        List<CronTrigger> jobRecords = [SELECT Id FROM CronTrigger  where CronJobDetail.Name =: jobName];
        if(jobRecords.isEmpty()){
            return false;
        }
        return true;
    }
}