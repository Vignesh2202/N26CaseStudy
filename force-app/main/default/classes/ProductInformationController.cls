public with sharing class ProductInformationController {
    
    @AuraEnabled( cacheable=true )  
    public static List<Product_Information__mdt> fetchProductInformation(Id caseRecordId) {
        
        List<Product_Information__mdt> productInfoList = new List<Product_Information__mdt>();
        
        try{
            Case c = [SELECT Id, ContactId, Contact.Product__c, Contact.Home_Country__c FROM Case WHERE Id = :caseRecordId]; //with security enforced
            
            if(String.isNotBlank(c.ContactId) && String.isNotBlank(c.Contact.Product__c) && String.isNotBlank(c.Contact.Home_Country__c)){
                productInfoList = [SELECT Id, ProductName__c, Country__c, CostPerCalendarMonth__c, ATMFee__c, CardReplacementCost__c FROM Product_Information__mdt WHERE Country__c = :c.Contact.Home_Country__c AND ProductName__c = :c.Contact.Product__c LIMIT 1];
            }  
        }
        
        catch(Exception e){
            //handle exception and log errors 
        }
        
        return productInfoList;
    }
}