public class ClientReportController {
    
    public String report        {get; set;}
        
    public ClientReportController(){
        String projectId = ApexPages.currentPage().getParameters().get('pId');
        this.report = JSON.serialize(new ClientReport(projectId));
        System.debug(this.report);
    }  
}