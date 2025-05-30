import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAccountsAndUpdateType from '@salesforce/apex/AccountProcessor.getAccountsAndUpdateType';

export default class AccountProcessorLWC extends LightningElement {
    @track accounts = [];
    @track isLoading = false;
    @track error;
    
    // Sort attributes
    sortedBy;
    sortDirection = 'asc';
    
    // Define columns for the datatable with sortable property
    columns = [
        { 
            label: 'Name', 
            fieldName: 'Name', 
            type: 'text',
            sortable: true 
        },
        { 
            label: 'Type', 
            fieldName: 'Type', 
            type: 'text',
            sortable: true 
        },
        { 
            label: 'Description', 
            fieldName: 'Description', 
            type: 'text',
            sortable: true 
        },
        { 
            label: 'Active', 
            fieldName: 'Active__c', 
            type: 'boolean',
            sortable: true 
        }
    ];
    
    // Handler for the Process Accounts button
    handleProcessAccounts() {
        this.isLoading = true;
        
        getAccountsAndUpdateType()
            .then(result => {
                this.accounts = [...result]; // Create a new array instance
                this.isLoading = false;
                
                // Show success message
                this.showToast('Success', 'Accounts processed successfully', 'success');
            })
            .catch(error => {
                this.error = error;
                this.isLoading = false;
                
                // Show error message
                this.showToast('Error', 'Error processing accounts: ' + this.reduceErrors(error), 'error');
                console.error('Error processing accounts:', error);
            });
    }
    
    // Handle column sort
    handleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        
        // Assign the sorted column and direction
        this.sortedBy = sortedBy;
        this.sortDirection = sortDirection;
        
        // Sort the data
        this.sortData(sortedBy, sortDirection);
    }
    
    // Sort the data according to the selected column and direction
    sortData(fieldName, direction) {
        let parseData = JSON.parse(JSON.stringify(this.accounts));
        let keyValue = (a) => {
            return a[fieldName];
        };
        
        // Sorting data
        parseData.sort((x, y) => {
            let a = keyValue(x) ? keyValue(x) : ''; // Handle null values
            let b = keyValue(y) ? keyValue(y) : '';
            
            // Special handling for boolean fields
            if (typeof a === 'boolean' && typeof b === 'boolean') {
                return direction === 'asc' ? a - b : b - a;
            }
            
            // Return the sorting logic based on direction
            return direction === 'asc' ? 
                (a > b ? 1 : a < b ? -1 : 0) : 
                (a < b ? 1 : a > b ? -1 : 0);
        });
        
        // Set sorted data to accounts attribute
        this.accounts = parseData;
    }
    
    // Helper method to show toast notifications
    showToast(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }
    
    // Helper to extract error messages
    reduceErrors(error) {
        if (typeof error === 'string') {
            return error;
        }
        
        // Extract error message from standard error object
        if (error.body && error.body.message) {
            return error.body.message;
        }
        
        return 'Unknown error';
    }
    
    // Calculate if we have accounts to display
    get hasAccounts() {
        return this.accounts && this.accounts.length > 0;
    }
    
    // Determine if we should show "no accounts" message
    get showNoAccountsMessage() {
        return !this.isLoading && (!this.accounts || this.accounts.length === 0);
    }
}