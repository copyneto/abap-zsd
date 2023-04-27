@EndUserText.label: 'CDS de projeção - Controle ordem Genérica'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_ORDEM_G
  as projection on ZI_SD_ORDEM_G
{
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_ORDERTYPE', element: 'Auart' }}]
  key Auart,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_MOTIVO_ORDEM_ENTITY', element: 'Augru' }}]
  key Augru,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_BWART', element: 'GoodsMovementType' }}]
      Bwart,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_BWART', element: 'GoodsMovementType' }}]
      Bwart1,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
