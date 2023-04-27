@EndUserText.label: 'De-Para’s dos centros faturamento/centros depósito fechado'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_CENTRO_FAT_DF
  as projection on ZI_SD_CENTRO_FAT_DF
{
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PlantStdVH', element: 'Plant' } } ]
  key CentroFaturamento,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PlantStdVH', element: 'Plant' } } ]
  key CentroDepFechado,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
