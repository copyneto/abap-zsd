@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cadastro de regra para incidência de IPI'
@Metadata.allowExtensions: true
define root view entity ZC_SD_IPI as projection on ZI_SD_IPI {
@Consumption.valueHelpDefinition: [{entity: {name: 'C_Plantvaluehelp', element: 'Plant' }}]
    key Werks,
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_DOMICILIO_FISCAL', element: 'Txjcd' }}]
    key Txjcd,
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_BRSCH', element: 'Brsch' }}]     
    key Brsch,
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_GRP_MERCADORIA', element: 'GrpMercadoria' }}]
    key Matkl,
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_DIREITO_FISCAL_IPI', element: 'Taxlaw' }}]    
    Taxlaw,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt
}
