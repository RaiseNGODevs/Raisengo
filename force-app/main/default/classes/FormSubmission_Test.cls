@isTest
public class FormSubmission_Test {
    @testSetup
    private static void setup() {
        FormSubmissions__c f = new FormSubmissions__c (Email__c = 'teste@email.com', Objects__c = 'Job_Offer__c,Contact');
        insert f;
        Job_Offer__c j = new Job_Offer__c(Job_Name__c = 'Full Stack');
        insert j;
    }
    @isTest
    private static void doPost() {
        Job_Offer__c j = [SELECT id,Name  FROM Job_Offer__c WHERE Job_Name__c = 'Full Stack'];
        
        String jsonString = '{ "masterName": "' + j.Name + '", "firstName": "Pedro", "surnames": "Costa", "email": "pedro@gmail.com", "phone": "934345454", "segurancaSocial": "Sim", "placeResidence": "São Roque, OAZ", "pt": "Avançado (C1, C2)", "eng": "Avançado (C1, C2)", "dateOfBirth": "01/04/2023", "cv": "https://drive.google.com/file/d/1VuMHkyHuuyawQz7Xu5WrgGJSsqJERaRQ/view?usp=sharing", "linkdin": "https://www.linkdin.com", "jobOffers": "Sim", "obs": "temp", "availableToTravel":"Yes","yearsExp":"1-2"}, "hasDegreeOrTraining": "Yes", "levelOfKnowledge":"Expert"}';
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/submitform';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(jsonString);
        RestContext.request = req;
        RestContext.response= res;
        FormSubmission.doPost();
        Test.stopTest();
        checkFormSubmission([SELECT id,First_Name__c,Surnames__c,Birthdate__c,CV__c, Email__c,English_Level__c,Portuguese_Level__c,LinkedIn__c,Seguranca_Social__c,Raise_N_Go_News__c,Phone__c,Place_of_Residence__c,Comments__c, YearsOfExperience__c, AvailableToTravel__c, Has_Degree__c, Level_of_Knowledge__c
                            FROM Form_Submission__c]);
        
        
    }
    
    @isTest
    private static void doPostException() {
        String jsonString = '{  "masterName": "Teste", "firstName": , "surnames": "Costa", "email": "pedro@gmail.com", "phone": 934345454, "segurancaSocial": "Sim", "placeResidence": "São Roque, OAZ", "pt": "Avançado (C1, C2)", "eng": "Avançado (C1, C2)", "dateOfBirth": "01/04/2023", "cv": "https://drive.google.com/file/d/1VuMHkyHuuyawQz7Xu5WrgGJSsqJERaRQ/view?usp=sharing", "linkdin": "https://www.linkdin.com", "jobOffers": "Sim", "obs": "temp","availableToTravel":"Yes","yearsExp":"1-2", "hasDegreeOrTraining": "Yes", "levelOfKnowledge":"Expert"}';
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/submitform';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(jsonString);
        RestContext.request = req;
        RestContext.response= res;
        FormSubmission.doPost();
        Test.stopTest();
        
    }
    
    @isTest
    private static void getObjectType() {
        Job_Offer__c j = [SELECT id,Name  FROM Job_Offer__c  WHERE Job_Name__c = 'Full Stack'];
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = j.id;
        Test.setFixedSearchResults(fixedSearchResults);
        List<String> l = FormSubmission_Helper.getObjectType(new List<String>{j.Name});
        Assert.areEqual('Job_Offer__c', l[0]);
    }
    
    
    //Helper methods
    
    
    private static void checkFormSubmission(Form_Submission__c submission) {
        Assert.areEqual(submission.First_Name__c , 'Pedro');
        Assert.areEqual(submission.Surnames__c , 'Costa');
        Assert.areEqual(submission.Birthdate__c , Date.parse('01/04/2023'));
        Assert.areNotEqual(submission.CV__c , '');
        Assert.areEqual(submission.Email__c , 'pedro@gmail.com');
        Assert.areEqual(submission.English_Level__c , 'Avançado (C1, C2)');
        Assert.areEqual(submission.Portuguese_Level__c , 'Avançado (C1, C2)');
        Assert.areEqual(submission.LinkedIn__c , 'https://www.linkdin.com');
        Assert.areEqual(submission.Seguranca_Social__c , 'Sim');
        Assert.areEqual(submission.Raise_N_Go_News__c , 'Sim');
        Assert.areEqual(submission.Phone__c , '934345454');
        Assert.areEqual(submission.Place_of_Residence__c , 'São Roque, OAZ');
        Assert.areEqual(submission.Comments__c , 'temp');
        Assert.areEqual(submission.YearsOfExperience__c , '1-2');
        Assert.areEqual(submission.AvailableToTravel__c , 'Yes');
        
    }
}