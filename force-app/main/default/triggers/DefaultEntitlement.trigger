trigger DefaultEntitlement on Case (Before Insert, Before Update) {
    if (Trigger.isBefore) {
        if(Trigger.isInsert){
            DefaultEntitlement_Handler.defaultServiceContract(Trigger.new);
        }else if(Trigger.isUpdate){
            DefaultEntitlement_Handler.defaultServiceContract(Trigger.new);
        }
    }
}