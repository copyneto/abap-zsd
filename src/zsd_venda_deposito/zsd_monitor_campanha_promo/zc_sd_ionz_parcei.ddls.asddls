@EndUserText.label: 'Lista de parceiros Ordens da campanha'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_IONZ_PARCEI 
  as projection on ZI_SD_IONZ_PARCEI {
//    @Consumption.valueHelpDefinition: [{entity: {name: 'I_PartnerFunctionText', element: 'PartnerFunction' }}] 
    @ObjectModel.text.element: ['PartnRole1']
    @EndUserText.label: 'Função Parceiro'
    key PartnRole,
    //@ObjectModel.readOnly: true
    @ObjectModel.virtualElement: true
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CONVESAO_PARVW'
    PartnRole1,
    @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_PARTNER_PF', element: 'Parceiro' }}]
    PartnNumb,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt
}
