@EndUserText.label: 'Formas de Cálculo DIFAL - Consumo'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_CALC_DIFAL as projection on ZI_SD_CALC_DIFAL {
    @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_SHIPTO', element: 'Region' }}]
    key Shipto,
    @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_GRP_MERCADORIA', element: 'GrpMercadoria' }}]   
    key MaterialGroup,
    @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_MATERIAL', element: 'Material' }}]   
    key Material,
    @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_FORM_DIFAL', element: 'DomvalueL' }}]  
    FormulaDifal,
    AliqFixa,
    Redbase,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt
}
