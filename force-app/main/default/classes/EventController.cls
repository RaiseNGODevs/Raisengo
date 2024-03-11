public class EventController {
	
    public Event_Form__c form {get;set;}
    public Contact Cont {get;set;}
    public String Name {get;set;}
    public String Observations {get;set;}
        
    public String alertName {get;set;}
    public String alertEmail {get;set;}
    public String alertOrganization {get;set;}    
    public String alertDuplicateEmail {get;set;}
       
    public String redirectPage {get;set;}
    public Integer              step {get;set;}
    
    public EventController(){
        String formId = ApexPages.currentPage().getParameters().get('id');
        
        
        form = [SELECT id, Form_Title__c, Confirmation_Title__c,Confirmation_Message__c, Data_Protection__c, Landing_Page__c, RecordType.Name
               FROM Event_Form__c
               WHERE id=:formId];
        
        Name = '';
        Observations = '';
        alertName = '';
        alertEmail = '';
        alertOrganization = '';

        Cont = new Contact();
        
        step = 1;
    }
    
    public pageReference Submit(){
        if(validation()){
            List<Contact> existContact = [SELECT id, Organization_Name__c
                                          FROM Contact
                                          WHERE Email =: Cont.Email LIMIT 1];
			Subscription__c inscr = new Subscription__c();
            inscr.Event_Form__c = form.id;
            inscr.Observations__c = observations;
            
            if(existContact.size() == 0){
                List<String> nomes = Name.split(' ',2);
            	Cont.FirstName= nomes[0];
				Cont.LastName= nomes[1];
                insert Cont;
                
                inscr.Contact__c = Cont.id;
                insert inscr;
                
            }else{
                existContact[0].Organization_Name__c = Cont.Organization_Name__c;
                update existContact[0];
                
                inscr.Contact__c = existContact[0].id;
                insert inscr;
            }
            
            if(form.Landing_Page__c != null){
                PageReference lp = new PageReference(form.Landing_Page__c);
                redirectPage = lp.getUrl();
                step = 2;
            }else{
                step = 3;
            }         	
        }
        
        return null;
    }
    
    public boolean validation(){
        
        boolean error = true;
        
        if(Name.split(' ',2).size() == 2 && Name.split(' ',2)[0] == ''){
            Name = Name.replaceAll('(\\s+)',' ');
    		Name = Name.split(' ',2)[1];
        }
        if(Name == '' || (Name.split(' ',2).size() != 2 || Name.split(' ',2)[1] == '')){
            alertName = 'Por favor, introduza pelo menos o seu primeiro e último nome.';
            error = false;
        }else
            alertName = '';
        
        Cont.Email = Cont.Email.replaceAll(' ','');
        if(Cont.Email == '' || Cont.Email == null){
            alertEmail = 'Por favor, introduza o seu email.';
            error = false;
        }else if (!Pattern.matches('.+\\@.+\\..+', Cont.Email) ){
            alertEmail = 'Por favor, introduza um endereço de email válido.';
            error = false;
        }else{
            alertEmail ='';
        }
        
        if(Cont.Organization_Name__c == '' || Cont.Organization_Name__c == null){
            alertOrganization = 'Por favor, introduza o nome da Organização.';
            error = false;
        }else
            alertOrganization = '';
          
        List<Subscription__c> exSub = new List<Subscription__c>();
        if(form.RecordType.Name == 'Event' || form.RecordType.Name == 'Evento'){
        	exSub = [SELECT id 
                     FROM Subscription__c 
                     WHERE Contact__r.Email = :Cont.Email
                     AND Event_Form__c = :form.Id];    
        }
        
        if(exSub.size() > 0){
            alertDuplicateEmail = 'Este utilizador já se encontra registado no evento. Qualquer dificuldade encontrada contacte a RaiseN\'GO';
            error = false;
        }else
            alertDuplicateEmail = '';
        
        return error;
    }
    
    public String getSiteURL(){
        Site site = [SELECT Subdomain, UrlPathPrefix FROM Site LIMIT 1];
		String url = 'https://' + site.Subdomain + '.secure.force.com';
        // /' + site.UrlPathPrefix;
        return url;
    }
}