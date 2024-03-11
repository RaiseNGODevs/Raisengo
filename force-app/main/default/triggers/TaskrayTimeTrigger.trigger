trigger TaskrayTimeTrigger on TASKRAY__trTaskTime__c (before insert, after insert, before update, after update, before delete, after undelete) {

    if( Trigger.isBefore && Trigger.isInsert ) TaskrayTimeTriggerHandler.onBeforeInsert(Trigger.new);
    if( Trigger.isBefore && Trigger.isUpdate ) TaskrayTimeTriggerHandler.onBeforeUpdate(Trigger.new, Trigger.old);
    
}