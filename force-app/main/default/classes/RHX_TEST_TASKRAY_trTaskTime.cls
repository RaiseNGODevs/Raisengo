@isTest(SeeAllData=true)
public class RHX_TEST_TASKRAY_trTaskTime {
	static testMethod void RHX_Testmethod() {
        List<sObject> sourceList = [SELECT Id 
			FROM TASKRAY__trTaskTime__c LIMIT 1];
        if(sourceList.size() == 0) {
            sourceList.add(
                    new TASKRAY__trTaskTime__c()
            );
        }
    	rh2.ParentUtil.UpsertRollupTestRecords( sourceList );
    }
}