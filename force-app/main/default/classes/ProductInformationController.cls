/*
*********************************************************
Apex Class Name    : ProductInformationController
Created Date       : May 10, 2024
Description        : This is class is used to retrive product information
Author             : Vignesh Mahalingam
Modification Log:
Ver   Date         Author                               Modification
1.0   10-05-2021   Vignesh Mahalingam                   Initial Version
*********************************************************
*/

public with sharing class ProductInformationController {
    
    // this method receives the case record Id and returns the product information of the contact associated with the case
    @AuraEnabled( cacheable=true )  
    public static List<ProductInformation__c> fetchProductInformation(String caseRecordId) {
        
        List<ProductInformation__c> productInfoList = new List<ProductInformation__c>();
        
        try{
            // get case details using Id
            List<Case> caseList = [SELECT Id, ContactId, Contact.Product__c, Contact.Home_Country__c FROM Case WHERE Id = :caseRecordId WITH SECURITY_ENFORCED];
            
            if(!caseList.isEmpty()){
                if(String.isNotBlank(caseList[0].ContactId) && String.isNotBlank(caseList[0].Contact.Product__c) && String.isNotBlank(caseList[0].Contact.Home_Country__c)){
                    
                    // fetch product information using the Contact's Home country and Product
                    productInfoList = [SELECT Id, ProductName__c, Country__c, CostPerCalendarMonth__c, ATMFee__c, CardReplacementCost__c FROM ProductInformation__c WHERE Country__c = :caseList[0].Contact.Home_Country__c AND ProductName__c = :caseList[0].Contact.Product__c WITH SECURITY_ENFORCED LIMIT 1];
                } 
            }
        }
        
        catch(Exception e){
            // handle exception and log errors 
        }
        
        return productInfoList;
    }
}