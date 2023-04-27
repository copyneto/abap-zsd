@EndUserText.label: 'Popup Motivo Recusa'
@Metadata.allowExtensions: true
define abstract entity ZC_SD_MOTIVO_RECUSA
{
  @Consumption.valueHelpDefinition: [ { entity  :  { name: 'ZI_CA_VH_ABGRU', element : 'SalesDocumentRjcnReason' } }]
  motivoRecusa : abgru;
}
