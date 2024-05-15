import { LightningElement, wire, api } from 'lwc';
import fetchProductInformation from '@salesforce/apex/ProductInformationController.fetchProductInformation';
import noProductsMessage from '@salesforce/label/c.No_Products_message';
import tableHeader from '@salesforce/label/c.Product_Information_Table_Header';

const COLUMNS = [
    { label: 'Product', fieldName: 'ProductName__c', sortable: false },
    { label: 'Country', fieldName: 'Country__c', sortable: false },
    { label: 'Cost per Calendar Month', fieldName: 'CostPerCalendarMonth__c', sortable: false },
    { label: 'ATM Fee', fieldName: 'ATMFee__c', sortable: false },
    { label: 'Card Replacement Cost', fieldName: 'CardReplacementCost__c', sortable: false }
];

export default class ProductInformation extends LightningElement {

    @api recordId;
    records;
    wiredRecords;
    error;
    columns = COLUMNS;
    noProducts = false;

    label = {
        noProductsMessage,
        tableHeader
    };
    
    // apex call to get product info 
    @wire(fetchProductInformation, { caseRecordId: '$recordId' })
    wiredRecs(value) {

        this.wiredRecords = value;
        const { data, error } = value;

        if (data) {
            this.records = data;
            if (this.records.length === 0) {
                this.noProducts = true;
            }
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.records = undefined;
        }
    }
}