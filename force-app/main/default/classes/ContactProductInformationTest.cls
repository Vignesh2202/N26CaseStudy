@IsTest
private class ContactProductInformationTest {
    
    @testSetup static void dataSetup() {
        
        // Create test records
        List <Contact> contactList = new List<Contact>();
        
        // create product information
        ProductInformation__c proInfo = new ProductInformation__c(ProductName__c = 'Standard', Country__c = 'DE', CostPerCalendarMonth__c = '€ 0', ATMFee__c = '1.7%', CardReplacementCost__c = '€ 6');
        insert proInfo;
        
        // create contact with valid country and product data
        Contact contact1 = new contact(FirstName ='Test', LastName = 'Contact1', Home_Country__c = 'DE', Product__c = 'Standard', UUID__c = 'vmAAE');
        
        // create contact with no product data
        Contact contact2 = new contact(FirstName ='Test', LastName = 'Contact2', Home_Country__c = 'DE', Product__c = '',UUID__c = 'vmAAB' );
        
        contactList.add(contact1);
        contactList.add(contact2);
        insert contactList;
    }
    
    @isTest static void testgetContactProductInfo() {
        
        Contact contact1 = [SELECT Id, UUID__c FROM Contact where Name = 'Test Contact1' LIMIT 1];
        Contact contact2 = [SELECT Id, UUID__c FROM Contact where Name = 'Test Contact2' LIMIT 1];
        
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/Contact/' + contact1.UUID__c;
        request.httpMethod = 'GET';
        RestContext.request = request;
        
        // call the method to test
        List<ContactProductInformation.ContactProductWrapper> conProInfo1 = ContactProductInformation.getContactProductInfo();
        
        // verify results - products information should not be empty for contact1
        system.assert(conProInfo1.size() > 0);
        
        
        // set up a test request
        RestRequest request2 = new RestRequest();
        request2.requestUri = '/services/apexrest/Contact/' + contact2.UUID__c;
        request2.httpMethod = 'GET';
        RestContext.request = request2;
        
        // call the method to test
        List<ContactProductInformation.ContactProductWrapper> conProInfo2 = ContactProductInformation.getContactProductInfo();
        
        // verify results - products information should be empty for contact2
        system.assert(conProInfo2.size() == 0);
    }
}