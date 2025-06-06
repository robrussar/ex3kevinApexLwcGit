import { LightningElement, track } from 'lwc';

export default class Ex3lwc1 extends LightningElement {
    @track tipoSelecionado = 'Todos';

    get typeOptions() {
        return [
            { label: 'Todos', value: 'Todos' },
            { label: 'Customer - Direct', value: 'Customer - Direct' },
            { label: 'Customer - Channel', value: 'Customer - Channel' },
            { label: 'Partner', value: 'Partner' }
        ];
    }

    handleTypeChange(event) {
        this.tipoSelecionado = event.detail.value;
        
        // Criar um CustomEvent e disparar para o componente pai
        const filterEvent = new CustomEvent('typefilter', {
            detail: this.tipoSelecionado
        });
        
        console.log('Disparando evento com valor:', this.tipoSelecionado);
        this.dispatchEvent(filterEvent);
    }
}