public class FormSubmission_Handler {
    
    public static void handleForm(FormSubmission_JSON formData) {
        Form_Submission__c submission = getSubmissionForm(formData);
        insert submission;
    }
    
    private static Form_Submission__c getSubmissionForm(FormSubmission_JSON formData) {
        Form_Submission__c submission = new Form_Submission__c ();
        submission.First_Name__c = formData.firstName;
        submission.Surnames__c = formData.surnames;
        submission.Birthdate__c = Date.parse(formData.dateOfBirth);
        submission.CV__c = formData.cv;
        submission.Email__c = formData.email;
        submission.English_Level__c = formdata.eng;
        submission.Portuguese_Level__c = formData.pt;
        submission.LinkedIn__c = formData.linkdin;
        submission.Seguranca_Social__c = formData.segurancaSocial;
        submission.Raise_N_Go_News__c = formData.jobOffers;
        submission.Has_Degree__c = formData.hasDegreeOrTraining;
        submission.Level_of_Knowledge__c = formData.levelOfKnowledge;
        submission.Phone__c = formData.phone;
        submission.Place_of_Residence__c = formData.placeResidence;
        submission.Comments__c = formData.obs;
        submission.YearsOfExperience__c = formData.yearsExp;
        submission.AvailableToTravel__c = formData.availableToTravel;
        submission.Master_Name__C = formData.masterName;
        
        return submission;
    }
    
}