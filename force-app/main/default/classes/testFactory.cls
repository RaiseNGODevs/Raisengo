public class testFactory {
    public static TimeEntry__c createTimeEntry(String entryId, String caseId, String description, DateTime startTime, DateTime endTime, String projectId){
        TimeEntry__c te = new TimeEntry__c();
        te.ClockifyTimeEntryId__c = entryId;
        te.CaseId__c = caseId;
        te.Description__c = description;
        te.StartTime__c = startTime;
        te.EndTime__c = endTime;
        te.Service_Contract__c = projectId;
        return te;
    }
    public static ServiceContract createServiceContract(String name, String accId, String projectId){
        ServiceContract cront = new ServiceContract();
        cront.Name = name;
        cront.AccountId = accId;
        cront.ClockifyProjectId__c = projectId;
        cront.StartDate = Date.today().addDays(-1);
        return cront;
    }
    public static ClockifySettings__c createSettings(String workspaceId, String updatekey, String stopKey, String deleteKey, String createKey, Integer logsTime){
        ClockifySettings__c clockS = new ClockifySettings__c();
        clockS.workspaceId__c = workspaceId;
        clockS.Signing_Update_Key__c = updatekey;
        clockS.Signing_Stop_Key__c = stopKey;
        clockS.Signing_Delete_Key__c = deleteKey;
        clockS.Signing_Create_Key__c = createKey;
        clockS.LogsLifeTime__c = logsTime;
        return clockS;
    }
    public static Case createCase(String subject, String status){
        Case ld = new Case();
        ld.Subject = subject;
        ld.Status = status;
        ld.LastModifiedDate = Date.today().addDays(-8);
        return ld;
    }
}