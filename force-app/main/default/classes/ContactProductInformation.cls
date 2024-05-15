/*
*********************************************************
Apex Class Name    : ContactProductInformation
Created Date       : May 10, 2024
Description        : This is class is used to retrive contact and product information
Author             : Vignesh Mahalingam
Modification Log:
Ver   Date         Author                               Modification
1.0   10-05-2021   Vignesh Mahalingam                   Initial Version
*********************************************************
*/

@RestResource(urlMapping='/Contact/*')
global with sharing class ContactProductInformation {
    
    // this method parses UUID from request and returns matching contact and its associated product information
    @HttpGet
    global static List<ContactProductWrapper> getContactProductInfo() {
        
        List<ContactProductWrapper> conProInfo = new List<ContactProductWrapper>();
        
        try{
            
            // get UUID from request
            RestRequest request = RestContext.request; 
            String contactUUID = request.requestURI.substring( request.requestURI.lastIndexOf('/')+1);
            
            // fetch contact using UUID
            List<Contact> conList = [SELECT Id, Name, Product__c,Home_Country__c FROM Contact WHERE UUID__c = :contactUUID WITH SECURITY_ENFORCED LIMIT 1];
            
            if(!conList.isEmpty()){     
                
                // fetch product details using Contact's Home country and Product
                if(String.isNotBlank(conList[0].Product__c) && String.isNotBlank(conList[0].Home_Country__c)){
                   List<ProductInformation__c> productInfoList = [SELECT Id, ProductName__c, Country__c, CostPerCalendarMonth__c, ATMFee__c, CardReplacementCost__c FROM ProductInformation__c WHERE Country__c = :conList[0].Home_Country__c AND ProductName__c = :conList[0].Product__c AND Active__c = TRUE WITH SECURITY_ENFORCED LIMIT 1];
                    
                    if(!productInfoList.isEmpty()){
                        conProInfo.add(new ContactProductWrapper(conList[0],productInfoList[0]));
                    }
                }
            }
        }
        
        catch(Exception e){
            // handle exception and log errors 
        }
        
        return conProInfo;
    }
    
    global class ContactProductWrapper {
        public Contact contactInfo {get; set;}
        public ProductInformation__c productInfo {get; set;}
        
        public ContactProductWrapper(Contact contactInfo, ProductInformation__c productInfo){
            this.contactInfo = contactInfo;
            this.productInfo = productInfo;
        }
    }
}