@isTest
public with sharing class CustomSettings_TEST {
    private static final String BATCH_NAME = 'Delete Logs Batch';
    @testSetup
    static void init() {
        ClockifySettings__c  cS = new ClockifySettings__c();
        insert cS;
    }
    
    @isTest
    static void testGetCustomSettings() {
        ClockifySettings__c cS = CustomSettings_CTRL.getCustomSettings();
        System.assertNotEquals(null, cS);
    }
    
    @isTest
    static void testSetCustomSettingsPositive() {
        CustomSettings_CTRL.setCustomSettings(30, 7, 'teste','teste', 'teste', 'teste', 'teste');
        ClockifySettings__c  ic = [SELECT id,Signing_Create_Key__c, autoCloseDays__c, Signing_Delete_Key__c, Signing_Stop_Key__c, Signing_Update_Key__c, workspaceId__c, LogsLifeTime__c
                                           FROM ClockifySettings__c];
        System.assertEquals(ic.Signing_Create_Key__c, 'teste', 'Create Key error!');
        System.assertEquals(ic.Signing_Delete_Key__c, 'teste', 'Delete Key error!');
        System.assertEquals(ic.Signing_Stop_Key__c, 'teste', 'Stop Key error!');
        System.assertEquals(ic.Signing_Update_Key__c, 'teste', 'Update Key error!');
        System.assertEquals(ic.workspaceId__c, 'teste', 'WorkspaceId error!');
        System.assertEquals(ic.LogsLifeTime__c, 30, 'Logs Liftime error!');
        System.assertEquals(ic.autoCloseDays__c, 7, 'autoCloseDays error!');
        System.assertEquals(1, [SELECT count() FROM CronTrigger  where CronJobDetail.Name =: BATCH_NAME], 'Erro agendamento');
    }
    
    @isTest
    static void testSetCustomSettingsNegative() {
        String response = CustomSettings_CTRL.setCustomSettings(-1, -1, 'teste','teste', 'teste', 'teste', 'teste');
        System.assertEquals('You missed some fields!', response);
    }
}