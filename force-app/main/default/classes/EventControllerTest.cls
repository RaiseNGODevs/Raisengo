@isTest
public class EventControllerTest {
    
    @testSetup
    public static void setup(){
        Event_Form__c form = new Event_Form__c(Form_Title__c = 'title', Confirmation_Title__c='confirm title',Confirmation_Message__c='test', Data_Protection__c='you agree text');
        insert form;

        ApexPages.currentPage().getParameters().put('id', form.id);
    }
    
    @isTest
    public static void test(){
        
        setup();
        
        EventController controller = new EventController();
        controller.Cont.Email = 'test@email.pt';
        controller.Name = ' name';
        controller.Cont.Organization_Name__c = 'test org';
        
        controller.validation();
        controller.Submit();
        
        
        // simular 2º registo
        controller.validation();
        
        
        // simular contacto existente mas que não estava registado neste evento
        Contact c = new Contact(FirstName='first', LastName='last', Email='testUser@email.pt');
        insert c;
        
        controller.Cont.Email = 'testUser@email.pt';
        controller.Name = 'firstName     lastName';
        controller.Cont.Organization_Name__c = 'RaiseN\'GO';
        controller.Submit();
    }
    
    @isTest
    public static void testExistingUser(){
        
        setup();
        
        EventController controller = new EventController();

        // simular contacto existente mas que não estava registado neste evento
        Contact c = new Contact(FirstName='first', LastName='last', Email='testUser@email.pt');
        insert c;
        
        controller.Cont.Email = 'testUser@email.pt';
        controller.Name = 'first last';
        controller.Cont.Organization_Name__c = 'RaiseN\'GO';
        controller.Submit();
    }
    
    @isTest
    public static void testErrors(){
        
        setup();
        
        EventController controller = new EventController();
        
        controller.Cont.Email = 'test';
        controller.validation();
        
        controller.Name = 'first';
        controller.Cont.Organization_Name__c = '';
        controller.Cont.Email = '';
        controller.validation();
        
    }
    
    @isTest
    public static void testSubscriptionCancel(){
        Event_Form__c form = new Event_Form__c(Form_Title__c = 'title', Confirmation_Title__c='confirm title',Confirmation_Message__c='test', Data_Protection__c='you agree text');
        insert form;
        
        Contact c = new Contact(FirstName='first', LastName='last', Email='testUser@email.pt');
        insert c;
        
        Subscription__c sub = new Subscription__c(Event_Form__c=form.id, Contact__c=c.id);
        insert sub;

        ApexPages.currentPage().getParameters().put('id', sub.id);
        CancelSubscriptionController controller = new CancelSubscriptionController();
        controller.updateSubscription();
    }
   
	@isTest
    public static void testSubscriptionConfirmation(){
         Contact c = new Contact(FirstName='first', LastName='last', Email='testUser@email.pt');
        insert c;
         Event_Form__c ev= new Event_Form__c (Name = 'teste');
        insert ev;
        Subscription__c insc = new Subscription__c (Presen_a_no_Evento__c = 'Não Presente', Event_Form__c = ev.id, Contact__c = c.id);
        insert insc;
        
        ApexPages.currentPage().getParameters().put('subscription',insc.id);
        EventConfirmationController controller = new EventConfirmationController();
        controller.checkLink();
        
    }      
    

}