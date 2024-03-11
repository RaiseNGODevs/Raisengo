@isTest
public class UnitTestEventConfirmation {
    @isTest static void Geral() {
        
        contact cccc= new contact (LastName = 'teste', Email = 'aaa@aaa.com');
        insert cccc;
        Event_Form__c event= new Event_Form__c(Name='Evento a');
        insert event;
        
        Subscription__c inscEventoContact = new Subscription__c (   Event_Form__c=event.Id, Contact__c = cccc.id);
        insert inscEventoContact;
        
        ApexPages.currentPage().getParameters().put('invitatedContact', '0');
        ApexPages.currentPage().getParameters().put('contact', '003m0000006bu7t');
        ApexPages.currentPage().getParameters().put('evento', 'a0Q240000022uUp');
        
        EventConfirmationController ec = new EventConfirmationController();
        ec.checkLink();
        
    
        ApexPages.currentPage().getParameters().put('invitatedContact', '003m0000006bu7t');
        ApexPages.currentPage().getParameters().put('contact', '003m0000006bu7t');
        ApexPages.currentPage().getParameters().put('evento', 'a0Q240000022uUp');
        
        EventConfirmationController ec2 = new EventConfirmationController();
        ec2.checkLink();
        
        ApexPages.currentPage().getParameters().put('invitatedContact', '003m0000006btyA');
        ApexPages.currentPage().getParameters().put('contact', '003m0000006bugt');
        ApexPages.currentPage().getParameters().put('evento', 'a0Q240000022uUp');
        
        EventConfirmationController ec3 = new EventConfirmationController();
        ec3.checkLink();
        
        ApexPages.currentPage().getParameters().put('invitatedContact', '0');
        ApexPages.currentPage().getParameters().put('contact', '003m0000006bugt');
        ApexPages.currentPage().getParameters().put('evento', 'a0Q240000022uUp');
        
        EventConfirmationController ec4 = new EventConfirmationController();
        ec4.checkLink();
        
        ApexPages.currentPage().getParameters().put('invitatedContact', '0');
        ApexPages.currentPage().getParameters().put('contact', 'a0wm0000000GQb1');
        ApexPages.currentPage().getParameters().put('evento', 'a0Q240000022uUp');
        
        EventConfirmationController ec5 = new EventConfirmationController();
        ec5.checkLink();
    
        ApexPages.currentPage().getParameters().put('invitatedContact', '003m0000006c6JP');
        ApexPages.currentPage().getParameters().put('contact', '003m0000006c6JO');
        ApexPages.currentPage().getParameters().put('evento', 'a0Q240000022uUp');
        
        EventConfirmationController ec6= new EventConfirmationController();
        ec5.checkLink();
    }

}