trigger NotWorkingDayTrigger on Not_Working_Days__c (before insert, after insert, before update, after update, before delete, after delete) {
    if( Trigger.isBefore && Trigger.isInsert ) NotWorkingDayTriggerHandler.onBeforeInsert(Trigger.new);
    if( Trigger.isBefore && Trigger.isUpdate ) NotWorkingDayTriggerHandler.onBeforeUpdate(Trigger.new, Trigger.old);
    if( Trigger.isAfter && Trigger.isInsert ) NotWorkingDayTriggerHandler.onAfterInsert(Trigger.new, Trigger.old);
    if( Trigger.isAfter && Trigger.isUpdate ) NotWorkingDayTriggerHandler.onAfterUpdate(Trigger.new, Trigger.old);
    if( Trigger.isAfter && Trigger.isDelete ) NotWorkingDayTriggerHandler.onAfterDelete(Trigger.old);
}