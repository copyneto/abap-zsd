@EndUserText.label: 'Abstract: Bloqueio de remessa'
define abstract entity ZI_SD_ABS_REMESSA_BLOQUEIO
{
  @EndUserText.label  : 'Bloqueio remessa'
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_REMESSA_BLOQUEIO', element: 'DeliveryBlockReason' } } ]
  DeliveryBlockReasonNew : lifsk;

}
