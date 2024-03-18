@RestResource(urlMapping='/time-entry')
global class TimeEntryManualAPI {
    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        String method = req.headers.get('Clockify-Webhook-Event-Type');
        try{
            String requestKey = req.headers.get('Clockify-Signature');
            if(securityChecker(method, requestKey)){
                switch on method {
                    when 'NEW_TIME_ENTRY' {
                        TimeEntryAPI_Handler.createAPI(req);
                    }
                    when 'TIMER_STOPPED' {
                        TimeEntryAPI_Handler.createApi(req);
                    }
                    when 'TIME_ENTRY_UPDATED' {
                        TimeEntryAPI_Handler.updateAPI(req);
                    }
                    when 'TIME_ENTRY_DELETED' {
                        TimeEntryAPI_Handler.deleteAPI(req);
                    }
                }
            }
            else{
                new IntegrationLogCreator('Clockify-API', method, 'Failed Security Validation or Unsupported API Method', 'Ignored', JSON.serialize(req.headers)).publish();
            }
        }catch(Exception error){
            new IntegrationLogCreator('Clockify-API', method, Json.serialize(new Map<String,String>{'error' => error.getTypeName(), 'message' => error.getMessage(), 'line' => String.valueOf(error.getLineNumber())}), 'Failure', req.requestBody.toString()).publish();
        }
    }
    private static Boolean securityChecker(String method, String requestKey){
        String key;
        switch on method {
            when 'NEW_TIME_ENTRY' {
                key = ClockifySettings__c.getInstance().Signing_Create_Key__c;
            }
            when 'TIME_ENTRY_UPDATED' {
                key = ClockifySettings__c.getInstance().Signing_Update_Key__c;
            }
            when 'TIME_ENTRY_DELETED' {
                key = ClockifySettings__c.getInstance().Signing_Delete_Key__c;
            }
            when 'TIMER_STOPPED' {
                key = ClockifySettings__c.getInstance().Signing_Stop_Key__c;
            }
        }
        if(requestKey == key){
            return true;
        }
        return false;
        
    }
}