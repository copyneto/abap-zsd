@EndUserText.label: 'CDS Consumo Mat. Campanha Promocional'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_MAT_PROMO
  as projection on ZI_SD_MAT_PROMO
{
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_MATERIAL', element: 'Material' }}]
  key Zmatnr,
  key Modelo,
      Zmenge,
      
//      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_UM', element: 'Unit' }}]
//      @Consumption.valueHelpDefinition: [{entity: {name: 'I_ProductUnitsOfMeasureVH', element: 'Unit' }}]
      
      @Consumption.valueHelpDefinition: [{  entity: {name: 'I_ProductUnitsOfMeasureVH', element: 'AlternativeUnit' }, 
                     additionalBinding: [{  element: 'Product', localElement: 'Zmatnr' }] }]       
      Zmeins,
      Zloevm,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_DEPOSITO', element: 'Lgort' }}]
      Zlgort,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_WERKS', element: 'WerksCode' }}]
      Zcentro,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
