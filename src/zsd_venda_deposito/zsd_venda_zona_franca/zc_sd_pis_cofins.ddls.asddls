@EndUserText.label: 'Cadastro regra incidência PIS e COFINS'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_PIS_COFINS as projection on ZI_SD_PIS_COFINS {
@Consumption.valueHelpDefinition: [{entity: {name: 'C_Plantvaluehelp', element: 'Plant' }}]
    key Werks,
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_BRSCH', element: 'Brsch' }}]      
    key Brsch,
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_TDT', element: 'J_1BTDT' }}]      
    key Tdt,
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_GRP_MERCADORIA', element: 'GrpMercadoria' }}]    
    key Matkl,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt
}
