public with sharing class ContaService {
    @AuraEnabled(cacheable=false) // Continuamos com cacheable=false
    public static List<Account> buscarContasPorTipo(String tipo) {
        try {
            List<Account> contas;
            
            if (String.isBlank(tipo) || tipo == 'Todos') {
                // Ajuste aqui para incluir o filtro de Industry
                contas = [SELECT Id, Name, Type, Industry, Description, Active__c 
                          FROM Account 
                          WHERE Type != null AND Industry != null
                          ORDER BY Name 
                          LIMIT 100];
            } else {
                // Ajuste aqui para incluir o filtro de Industry
                contas = [SELECT Id, Name, Type, Industry, Description, Active__c 
                          FROM Account 
                          WHERE Type = :tipo AND Industry != null
                          ORDER BY Name 
                          LIMIT 100];
            }
            
            return contas;
        } catch (Exception e) {
            throw new AuraHandledException('Erro ao buscar contas: ' + e.getMessage());
        }
    }
}