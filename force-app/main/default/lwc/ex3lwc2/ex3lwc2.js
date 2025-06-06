import { LightningElement, api, track, wire } from 'lwc';
import buscarContasPorTipo from '@salesforce/apex/ContaService.buscarContasPorTipo';

export default class Ex3lwc2 extends LightningElement {
    @track contas = [];
    @track error;
    @track isLoading = false;
    @track tipoAtual = 'Todos';
    
    columns = [
        { label: 'Nome', fieldName: 'Name', type: 'text' },
        { label: 'Type', fieldName: 'Type', type: 'text' },
        { label: 'Industry', fieldName: 'Industry', type: 'text' },
        { label: 'Active', fieldName: 'Active__c', type: 'text' },
        { label: 'Description', fieldName: 'Description', type: 'text' }
    ];
    
    connectedCallback() {
        // Carregar todas as contas inicialmente
        this.buscarContas('Todos');
    }
    
    @api
    handleTypeFilter(event) {
        // Receber o tipo selecionado do evento
        const tipoSelecionado = event.detail;
        this.tipoAtual = tipoSelecionado;
        
        console.log('Filtro recebido:', tipoSelecionado);
        this.buscarContas(tipoSelecionado);
    }
    
    buscarContas(tipo) {
        this.isLoading = true;
        this.error = undefined;

        buscarContasPorTipo({ tipo: tipo })
            .then(result => {
                this.contas = result;
                console.log('Contas carregadas:', this.contas.length);
            })
            .catch(error => {
                this.error = 'Erro ao carregar contas: ' + (error.body ? error.body.message : error.message);
                this.contas = [];
                console.error('Erro:', this.error);
            })
            .finally(() => {
                this.isLoading = false;
            });
    }
}