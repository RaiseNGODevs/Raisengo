@RestResource(urlMapping='/submitform')
global class FormSubmission {
    @HttpPost
    global static void doPost() {
        try {
            RestRequest req = RestContext.request;
            String requestBody = req.requestBody.toString();
            FormSubmission_Handler.handleForm(FormSubmission_JSON.parse(requestBody));
        }catch (Exception e) {
            sendEmail(e);
        }
    }
    
    private static void sendEmail(Exception e) {
        FormSubmissions__c formSubmissions = FormSubmissions__c.getInstance();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new List<String>{formSubmissions.email__c});
        email.setSubject('Error Creating FormSubmission ' +e.getTypeName());
        email.setPlainTextBody(e.getTypeName() + ' ' + e.getMessage() + ' ' +e.getStackTraceString() + ' ' + e.getStackTraceString());
        if(!Test.isRunningTest()) {Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});}
    }
}