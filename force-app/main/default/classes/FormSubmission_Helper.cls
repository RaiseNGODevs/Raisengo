public class FormSubmission_Helper {
    
    @InvocableMethod(label = 'Get object type')
    public static List<String> getObjectType(List<String> masterNames) {
        Id masterObejctId = getMasterObject(masterNames[0]);
        return new List<String>{String.ValueOf(masterObejctId.getSObjectType())};
    }
    
    private static Id getMasterObject(String masterName) {
        FormSubmissions__c formSubmissions = FormSubmissions__c.getInstance();
        List<String> masterObjects = formSubmissions.Objects__c.split(',');
        String query = 'FIND \'' + masterName + '\' IN ALL FIELDS RETURNING ';
        for(String masterObject : masterObjects) {query += masterObject + '(Id),';}
        query = query.substring(0, query.length() - 1);
        List<List<sObject>> searchResults = Search.query(query);
        return searchResults[0][0].id;
    }
    
}