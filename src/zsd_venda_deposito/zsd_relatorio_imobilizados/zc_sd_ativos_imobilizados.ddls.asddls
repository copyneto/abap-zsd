@EndUserText.label: 'Projeção - Ativos Imobilizados'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_SD_ATIVOS_IMOBILIZADOS
  as projection on ZI_SD_ATIVOS_IMOBILIZADOS
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8

      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BILLINGDOCUMENTTYPE',
                                                     element: 'BillingDocumentType'}}]
  key Fkart,

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_REGIO_BR',
                                                   element: 'Region'}}]
  key RegiaoSaida,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_REGIO_BR',
                                                   element: 'Region'}}]
  key RegiaoDestino,
      DiasAtraso1,
      DiasAtraso2,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
