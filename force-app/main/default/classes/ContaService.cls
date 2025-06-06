public with sharing class ContaService {
    @AuraEnabled(cacheable=false) // Ajustar para cacheable=false
    public static List<Account> buscarContasPorTipo(String tipo) {
        try {
            List<Account> contas;
            
            if (String.isBlank(tipo) || tipo == 'Todos') {
                contas = [SELECT Id, Name, Type, Industry, Description, Active__c 
                          FROM Account 
                          WHERE Type != null 
                          ORDER BY Name 
                          LIMIT 100];
            } else {
                contas = [SELECT Id, Name, Type, Industry, Description, Active__c 
                          FROM Account 
                          WHERE Type = :tipo 
                          ORDER BY Name 
                          LIMIT 100];
            }
            
            return contas;
        } catch (Exception e) {
            throw new AuraHandledException('Erro ao buscar contas: ' + e.getMessage());
        }
    }
}