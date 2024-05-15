@isTest
private class ProductInformationControllerTest {
    
    @testSetup static void dataSetup() {
        
        // create test records
        List <Contact> contactList = new List<Contact>();
        List <Case> caseList = new List<Case>();
        
        // create product information
        ProductInformation__c proInfo = new ProductInformation__c(ProductName__c = 'Standard', Country__c = 'DE', CostPerCalendarMonth__c = '€ 0', ATMFee__c = '1.7%', CardReplacementCost__c = '€ 6');
        insert proInfo;
        
        // create contact with valid country and product data
        Contact contact1 = new contact(FirstName ='Test', LastName = 'Contact1', Home_Country__c = 'DE', Product__c = 'Standard');
        
        // create contact with no product data
        Contact contact2 = new contact(FirstName ='Test', LastName = 'Contact2', Home_Country__c = 'DE', Product__c = '');
        
        contactList.add(contact1);
        contactList.add(contact2);
        insert contactList;
        
        // create cases with contacts
        Case case1 = new Case(ContactId = contact1.Id);
        Case case2 = new Case(ContactId = contact2.Id);
        
        caseList.add(case1);
        caseList.add(case2);
        insert caseList;
    }
    
    @isTest static void testfetchProductInformation() {
        
        Case case1 = [SELECT Id FROM Case WHERE Contact.Name = 'Test Contact1' LIMIT 1];
        Case case2 = [SELECT Id FROM Case WHERE Contact.Name = 'Test Contact2' LIMIT 1];
        
        // method call to get product info
        List <ProductInformation__c> productInfo1 = ProductInformationController.fetchProductInformation(case1.Id);
        List <ProductInformation__c> productInfo2 = ProductInformationController.fetchProductInformation(case2.Id);
        
        // product information should not be empty for case1's contact
        system.assert(productInfo1.size() > 0);
        
        // product information should be empty for case2's contact
        system.assert(productInfo2.size() == 0);
    }
}