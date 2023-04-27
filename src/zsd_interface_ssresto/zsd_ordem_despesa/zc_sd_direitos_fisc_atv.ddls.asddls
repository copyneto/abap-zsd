@EndUserText.label: 'CDS proj - Direitos fiscais p/ Ordens Operações Especiais'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_DIREITOS_FISC_ATV as projection on ZI_SD_DIREITOS_FISC_ATV {
    key Shipfrom,
    @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_ORDERTYPE', element: 'Auart' }}]
    key Auart,
    //@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_DIREITO_FISCAL_IPI', element: '' }}]
    J1btaxlw1,
    @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_DIREITO_FISCAL_IPI', element: 'Taxlaw' }}]
    J1btaxlw2,
    J1btaxlw5,
    J1btaxlw4,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt
}
