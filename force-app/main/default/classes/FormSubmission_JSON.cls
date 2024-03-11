public class FormSubmission_JSON{
	public String firstName;	
	public String surnames;	
	public String email;	
	public String phone;	
	public String segurancaSocial;	
	public String pt;	
	public String eng;	
	public String dateOfBirth;	
	public String cv;
	public String linkdin;	
	public String jobOffers;	
    public String placeResidence;
    public String obs;
    public String masterName;
    public String availableToTravel;
    public String yearsExp;
    public String hasDegreeOrTraining;
    public String levelOfKnowledge;
    
	public static FormSubmission_JSON parse(String json){
		return (FormSubmission_JSON) System.JSON.deserialize(json, FormSubmission_JSON.class);
	}
}