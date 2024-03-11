public with sharing class IntegrationLogCreator {
    String source;
    String endpointType;
    String message;
    String requestBody;
    String result;

    public IntegrationLogCreator(String source, String endpointType, String message, String result, String requestBody){
        this.source = source;
        this.endpointType = endpointType;
        this.message = message;
        this.requestBody = requestBody;
        this.result = result;
    }
    public void publish(){
        Integration_Log__c log = new Integration_Log__c();
        log.Source__c = this.source;
        log.Endpoint_Type__c = this.endpointType;
        log.Message__c = this.message;
        log.RequestBody__c = this.requestBody;
        log.Result__c = this.result;
        Database.insert(log);
    }
}