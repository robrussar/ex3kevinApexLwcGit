public with sharing class AccountProcessor {
    
    @AuraEnabled(cacheable=false)
    public static List<Account> getAccountsAndUpdateType() {
        // Query only accounts with Type field populated
        List<Account> accounts = [SELECT Id, Name, Type, Description, Active__c 
                                 FROM Account 
                                 WHERE Type != null];
        
        // Clonar os registros para evitar alterar os originais
        List<Account> accountsForDisplay = new List<Account>();
        
        for (Account acc : accounts) {
            // Criar um clone não-persistente da conta
            Account displayAccount = acc.clone(false, true, false, false);
            
            // Verificar e modificar o Type apenas no clone (não no registro original)
            if (displayAccount.Type == 'Customer - Direct') {
                displayAccount.Type = 'Customer - Robert';
            } else {
                displayAccount.Type = 'Customer - Channel';
            }
            
            accountsForDisplay.add(displayAccount);
        }
        
        // Retornar os registros clonados com Type modificado (sem atualizar o banco de dados)
        return accountsForDisplay;
    }
}