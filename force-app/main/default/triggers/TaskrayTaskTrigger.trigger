trigger TaskrayTaskTrigger on TASKRAY__Project_Task__c (before insert, after insert, before update, after update, before delete, after undelete) {
    if( Trigger.isBefore && Trigger.isInsert ) TaskrayTaskTriggerHandler.onBeforeInsert(Trigger.new);
    if( Trigger.isBefore && Trigger.isUpdate ) TaskrayTaskTriggerHandler.onBeforeUpdate(Trigger.new, Trigger.old);
}