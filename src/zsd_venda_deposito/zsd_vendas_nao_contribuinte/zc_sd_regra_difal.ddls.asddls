@EndUserText.label: 'Regras DIFAL - Consumo'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_REGRA_DIFAL as projection on ZI_SD_REGRA_DIFAL {
    @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_ORDERTYPE', element: 'Auart' }}]    
    key TypeOrder,
    @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_TAXCODE', element: 'Taxcode' }}]  
    TaxCode,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt
}
