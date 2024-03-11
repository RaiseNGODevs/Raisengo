public without sharing class DefaultEntitlement_Handler {
    /*public static void defaultEntitler(List<Case> filterList){
        List<Case> newList = new List<Case>();
        for (Case c : filterList) {
            if (String.isBlank(c.EntitlementId)) {
                newList.add(c);
            }
        }
        if(newList.isEmpty()){
            return;
        }
        Set<Id> contactIds = new Set<Id>();
        Set<Id> acctIds = new Set<Id>();
        for (Case c : newList) {
            contactIds.add(c.ContactId);
            acctIds.add(c.AccountId);
        }
        List <EntitlementContact> entlContacts = 
                    [SELECT e.EntitlementId,e.ContactId,e.Entitlement.AssetId 
                    FROM EntitlementContact e
                    WHERE e.ContactId in :contactIds
                    AND e.Entitlement.EndDate >= Today 
                    AND e.Entitlement.StartDate <= Today];
        if(entlContacts.isEmpty()==false){
            for(Case c : newList){
                if(c.EntitlementId == null && c.ContactId != null){
                    for(EntitlementContact ec:entlContacts){
                        if(ec.ContactId==c.ContactId){
                            c.EntitlementId = ec.EntitlementId;
                            if(c.AssetId==null && ec.Entitlement.AssetId!=null)
                                c.AssetId=ec.Entitlement.AssetId;
                            break;
                        }
                    } 
                }
            } 
        } else{
            List <Entitlement> entls = [SELECT e.StartDate, e.Id, e.EndDate, 
                    e.AccountId, e.AssetId
                    FROM Entitlement e
                    WHERE e.AccountId in :acctIds And e.EndDate >= Today 
                    AND e.StartDate <= Today];
            if(entls.isEmpty()==false){
                for(Case c : newList){
                    if(c.EntitlementId == null && c.AccountId != null){
                        for(Entitlement e:entls){
                            if(e.AccountId==c.AccountId){
                                c.EntitlementId = e.Id;
                                if(c.AssetId==null && e.AssetId!=null)
                                    c.AssetId=e.AssetId;
                                break;
                            }
                        } 
                    }
                } 
            }
        }
    }*/
    public static void defaultServiceContract(List<Case> filterList){
        List<Case> newList = new List<Case>();
        for (Case c : filterList) {
            if (String.isBlank(c.Service_Contract__c) || String.isBlank(c.EntitlementId)) {
                newList.add(c);
            }
        }
        if(newList.isEmpty()){
            return;
        }
        Set<Id> contactIds = new Set<Id>();
        Set<Id> acctIds = new Set<Id>();
        for (Case c : newList) {
            if(!String.isBlank(c.ContactId)){
                contactIds.add(c.ContactId);
            }if(!String.isBlank(c.AccountId)){
                acctIds.add(c.AccountId);
            }
        }
        List<ServiceContract> serviceContractList = 
                    [SELECT ID, ContactId, AccountId, 
                            (SELECT ID
                            FROM Entitlements
                            WHERE Status = 'Active'
                            ORDER BY CreatedDate DESC
                            LIMIT 1)
                        FROM ServiceContract
                        WHERE (ContactId IN :contactIds
                        OR AccountId IN :acctIds)
                        AND Status = 'Active'
                        AND EndDate >= Today 
                        AND StartDate <= Today];
        Map<ID, ServiceContract> serviceMap = new Map<ID, ServiceContract>();
        if(serviceContractList.isEmpty()){
            return;
        }
        for(ServiceContract serviceContract : serviceContractList){
            if(String.isNotBlank(serviceContract.ContactId)){
                serviceMap.put(serviceContract.ContactId, serviceContract);
            }
            if(String.isNotBlank(serviceContract.AccountId)){
                serviceMap.put(serviceContract.AccountId, serviceContract);
            }
        }
        for(Case c : newList){
            ServiceContract sContract;
            if(serviceMap.containsKey(c.ContactId)){
                sContract = serviceMap.get(c.ContactId);
                c.Service_Contract__c = sContract.ID;
                c.EntitlementId = sContract.Entitlements.isEmpty() ? c.EntitlementId : sContract.Entitlements[0].ID;
            }else if(serviceMap.containsKey(c.AccountId)){
                sContract = serviceMap.get(c.AccountId);
                c.Service_Contract__c = sContract.ID;
                c.EntitlementId = sContract.Entitlements.isEmpty() ? c.EntitlementId : sContract.Entitlements[0].ID;
            } 
        } 
    }
}