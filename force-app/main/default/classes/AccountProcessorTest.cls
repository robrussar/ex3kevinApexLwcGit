@isTest
private class AccountProcessorTest {
    
    @TestSetup
    static void makeData() {
        // Criar contas de teste com diferentes tipos
        List<Account> testAccounts = new List<Account>();
        
        // Conta com tipo "Customer - Direct" que deve ser alterada para "Customer - Robert"
        Account directAccount = new Account(
            Name = 'Test Direct Account',
            Type = 'Customer - Direct',
            Description = 'Teste de conta direta'
            // Removido o campo Active__c que estava causando o erro
        );
        testAccounts.add(directAccount);
        
        // Conta com tipo diferente que deve ser alterada para "Customer - Channel"
        Account otherAccount = new Account(
            Name = 'Test Other Account',
            Type = 'Prospect',
            Description = 'Teste de outra conta'
            // Removido o campo Active__c que estava causando o erro
        );
        testAccounts.add(otherAccount);
        
        // Conta sem tipo que não deve ser retornada pela consulta
        Account noTypeAccount = new Account(
            Name = 'Test No Type Account',
            Description = 'Teste de conta sem tipo'
            // Removido o campo Active__c que estava causando o erro
        );
        testAccounts.add(noTypeAccount);
        
        insert testAccounts;
    }
    
    @isTest
    static void testGetAccountsAndUpdateType() {
        // Iniciar monitoramento de teste
        Test.startTest();
        
        // Chamar o método a ser testado
        List<Account> resultAccounts = AccountProcessor.getAccountsAndUpdateType();
        
        // Finalizar monitoramento de teste
        Test.stopTest();
        
        // Verificações - devem existir apenas 2 contas (com tipo preenchido)
        System.assertEquals(2, resultAccounts.size(), 'Deveria retornar apenas as contas com Type preenchido');
        
        // Verificar se as contas foram processadas corretamente
        Map<String, Account> accountsByName = new Map<String, Account>();
        for (Account acc : resultAccounts) {
            accountsByName.put(acc.Name, acc);
        }
        
        // Verificar a conta que deveria ter sido alterada para "Customer - Robert"
        Account processedDirectAccount = accountsByName.get('Test Direct Account');
        System.assertNotEquals(null, processedDirectAccount, 'A conta direta deve existir nos resultados');
        System.assertEquals('Customer - Robert', processedDirectAccount.Type, 'Tipo incorreto para a conta direta');
        
        // Verificar a conta que deveria ter sido alterada para "Customer - Channel"
        Account processedOtherAccount = accountsByName.get('Test Other Account');
        System.assertNotEquals(null, processedOtherAccount, 'A outra conta deve existir nos resultados');
        System.assertEquals('Customer - Channel', processedOtherAccount.Type, 'Tipo incorreto para a outra conta');
        
        // Verificar que os registros originais não foram alterados
        List<Account> originalAccounts = [SELECT Id, Name, Type FROM Account WHERE Type != null];
        for (Account original : originalAccounts) {
            if (original.Name == 'Test Direct Account') {
                System.assertEquals('Customer - Direct', original.Type, 'O registro original não deveria ter sido alterado');
            }
            else if (original.Name == 'Test Other Account') {
                System.assertEquals('Prospect', original.Type, 'O registro original não deveria ter sido alterado');
            }
        }
    }
    
    @isTest
    static void testGetAccountsAndUpdateTypeWithNoResults() {
        // Deletar todas as contas com Type preenchido para simular um cenário sem resultados
        delete [SELECT Id FROM Account WHERE Type != null];
        
        // Iniciar monitoramento de teste
        Test.startTest();
        
        // Chamar o método a ser testado
        List<Account> resultAccounts = AccountProcessor.getAccountsAndUpdateType();
        
        // Finalizar monitoramento de teste
        Test.stopTest();
        
        // Verificar que retornou uma lista vazia
        System.assertEquals(0, resultAccounts.size(), 'Deveria retornar lista vazia quando não houver contas com Type');
    }
}