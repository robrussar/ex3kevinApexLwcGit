@isTest
public class ContaServiceTest {
    @testSetup
    static void setupTestData() {
        // Criar contas de teste com diferentes tipos
        List<Account> contasTeste = new List<Account>();
        
        // Conta tipo Customer - Direct
        Account contaDirect = new Account(
            Name = 'Teste Customer Direct',
            Type = 'Customer - Direct',
            Industry = 'Technology',
            Description = 'Conta de teste tipo Customer Direct'
        );
        contasTeste.add(contaDirect);
        
        // Conta tipo Customer - Channel
        Account contaChannel = new Account(
            Name = 'Teste Customer Channel',
            Type = 'Customer - Channel',
            Industry = 'Healthcare',
            Description = 'Conta de teste tipo Customer Channel'
        );
        contasTeste.add(contaChannel);
        
        // Conta tipo Partner
        Account contaPartner = new Account(
            Name = 'Teste Partner',
            Type = 'Partner',
            Industry = 'Finance',
            Description = 'Conta de teste tipo Partner'
        );
        contasTeste.add(contaPartner);
        
        insert contasTeste;
    }
    
    @isTest
    static void testBuscarPorTipoEspecifico() {
        // Testar busca por tipo específico
        Test.startTest();
        List<Account> contasDirect = ContaService.buscarContasPorTipo('Customer - Direct');
        Test.stopTest();
        
        // Verificar resultados
        System.assertEquals(1, contasDirect.size(), 'Deveria retornar apenas 1 conta do tipo Customer - Direct');
        System.assertEquals('Customer - Direct', contasDirect[0].Type, 'O tipo da conta deveria ser Customer - Direct');
        System.assertEquals('Teste Customer Direct', contasDirect[0].Name, 'O nome da conta está incorreto');
    }
    
    @isTest
    static void testBuscarTodos() {
        // Testar busca por todos os tipos
        Test.startTest();
        List<Account> todasContas = ContaService.buscarContasPorTipo('Todos');
        Test.stopTest();
        
        // Verificar resultados
        System.assertEquals(3, todasContas.size(), 'Deveria retornar todas as 3 contas de teste');
        
        // Mapear os tipos por nome para verificação fácil
        Set<String> tipos = new Set<String>();
        for(Account acc : todasContas) {
            tipos.add(acc.Type);
        }
        
        // Verificar que todos os tipos de contas foram retornados
        System.assert(tipos.contains('Customer - Direct'), 'Deveria conter conta do tipo Customer - Direct');
        System.assert(tipos.contains('Customer - Channel'), 'Deveria conter conta do tipo Customer - Channel');
        System.assert(tipos.contains('Partner'), 'Deveria conter conta do tipo Partner');
    }
    
    @isTest
    static void testBuscarTipoNulo() {
        // Testar busca com tipo nulo (deve trazer todos)
        Test.startTest();
        List<Account> contasNulo = ContaService.buscarContasPorTipo(null);
        Test.stopTest();
        
        System.assertEquals(3, contasNulo.size(), 'Deveria retornar todas as contas quando o tipo é nulo');
    }
    
    @isTest
    static void testBuscarContasPorTipoVazio() {
        Test.startTest();
        List<Account> contasVazio = ContaService.buscarContasPorTipo('');
        Test.stopTest();
        
        System.assertEquals(3, contasVazio.size(), 'Deveria retornar todas as contas quando o tipo é vazio');
    }
    
    @isTest
    static void testCompleteCoverage() {
        Test.startTest();
        
        // Testar com tipo específico
        List<Account> contasDirect = ContaService.buscarContasPorTipo('Customer - Direct');
        System.assertEquals(1, contasDirect.size(), 'Deveria retornar 1 conta');
        
        // Testar com 'Todos'
        List<Account> todasContas = ContaService.buscarContasPorTipo('Todos');
        System.assertEquals(3, todasContas.size(), 'Deveria retornar 3 contas');
        
        // Testar com null
        List<Account> contasNull = ContaService.buscarContasPorTipo(null);
        System.assertEquals(3, contasNull.size(), 'Deveria retornar 3 contas');
        
        // Testar com string vazia
        List<Account> contasVazias = ContaService.buscarContasPorTipo('');
        System.assertEquals(3, contasVazias.size(), 'Deveria retornar 3 contas');

        List<Account> contasInexistente = ContaService.buscarContasPorTipo('NonExistentType');
        System.assertEquals(0, contasInexistente.size(), 'Deveria retornar 0 contas');
        
        // Testar para forçar a exceção
        try {
            ContaService.buscarContasPorTipo('ForceException');
            System.assert(false, 'Deveria ter lançado uma exceção'); // Adicionado assert para garantir que a exceção seja lançada
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('Forçando uma exceção para teste de cobertura.'), 'Mensagem de exceção incorreta');
        } catch (Exception e) {
            System.assert(false, 'Deveria ter lançado AuraHandledException');
        }
        
        Test.stopTest();
    }
}