@AbapCatalog.sqlViewName: 'ZCSDRELDISP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Relatório de disponibilidade'

@VDM.viewType: #CONSUMPTION
@OData.publish: true
@OData.entitySet.name: 'AvailabilityReport'

define view ZC_SD_REL_DISPONIBILIDADE
  as select from ZI_SD_REL_DISPONIBILIDADE
{
      @UI.lineItem: [ { position: 10 }]
      @UI.selectionField: [{position: 10 }]
      @EndUserText.label: 'Material'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MATERIAL', element: 'Material' }} ]
      @Consumption.filter.mandatory: true
  key Material,

      @UI.lineItem: [ { position: 20 }]
      @UI.selectionField: [{position: 20 }]
      @EndUserText.label: 'Centro'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' }} ]
  key Plant,
      
      @UI.lineItem: [ { position: 30 }]
      @UI.selectionField: [{position: 30 }]
      @EndUserText.label: 'Depósito'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_LGORT', element: 'StorageLocation' }} ]
  key Deposito,
      
      @UI.lineItem: [ { position: 40 }]
      @EndUserText.label: 'Descrição do Material'
      Descricao,
      
      @UI.lineItem: [ { position: 50 }]
      @UI.selectionField: [{position: 40 }]
      @EndUserText.label: 'Centro Dep. Fechado'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PlantStdVH', element: 'Plant' }} ]
      CentroDepFechado,
      
      @UI.hidden: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VH_UNIDADE_MEDIDA', element: 'UnitOfMeasure' }} ]
      MaterialUnit,
      
      @UI.lineItem: [ { position: 70 }]
      @EndUserText.label: 'Estoque Utilização Livre'
      QtdEstoqueLivre,
      
      @UI.lineItem: [ { position: 80 }]
      @EndUserText.label: 'Estoque Depósito Fechado'
      QtdDepositoFechado,
      
      @UI.lineItem: [ { position: 90 }]
      @EndUserText.label: 'Qtd. em Ordem'
      QtdOrdem,
      
      @UI.lineItem: [ { position: 100 }]
      @EndUserText.label: 'Qtd. em Remessa'
      QtdRemessa,
      
      @UI.lineItem: [ { position: 110 }]
      @Semantics.quantity.unitOfMeasure: 'MaterialUnit'
      @EndUserText.label: 'Saldo'
      ( QtdEstoqueLivre + QtdDepositoFechado - QtdOrdem - QtdRemessa ) as Saldo
        
}
