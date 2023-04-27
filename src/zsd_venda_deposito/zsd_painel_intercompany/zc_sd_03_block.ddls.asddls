@EndUserText.label: 'Definir bloqueio'
define abstract entity ZC_SD_03_block
{
  @EndUserText    : {label: 'Código Bloqueio', quickInfo: 'Código do Bloqueio de Remessa'}
  @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_MM_VH_MOTIVO_BLOQ_REMESSA', element : 'DeliveryBlockReason' }}]
  DelivBlockReason : lifsk;
}
