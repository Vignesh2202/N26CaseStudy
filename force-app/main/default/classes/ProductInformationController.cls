public with sharing class ProductInformationController {
    
    @AuraEnabled( cacheable=true )  
    public static List<ProductInformation__c> fetchProductInformation(String caseRecordId) {
        
        List<ProductInformation__c> productInfoList = new List<ProductInformation__c>();
        
        try{
            List<Case> caseList = [SELECT Id, ContactId, Contact.Product__c, Contact.Home_Country__c FROM Case WHERE Id = :caseRecordId WITH SECURITY_ENFORCED];
            if(!caseList.isEmpty()){
                if(String.isNotBlank(caseList[0].ContactId) && String.isNotBlank(caseList[0].Contact.Product__c) && String.isNotBlank(caseList[0].Contact.Home_Country__c)){
                    productInfoList = [SELECT Id, ProductName__c, Country__c, CostPerCalendarMonth__c, ATMFee__c, CardReplacementCost__c FROM ProductInformation__c WHERE Country__c = :caseList[0].Contact.Home_Country__c AND ProductName__c = :caseList[0].Contact.Product__c WITH SECURITY_ENFORCED LIMIT 1];
                } 
            }
        }
        
        catch(Exception e){
            //handle exception and log errors 
        }
        
        return productInfoList;
    }
}