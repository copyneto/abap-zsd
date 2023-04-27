@EndUserText.label: 'Gestão de  Preço - Lista de preço'
@Metadata.allowExtensions: true

define abstract entity ZC_SD_GESTAO_PRECO_COND_POPUP
{
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_GESTAO_PRECO_COND', element: 'PriceTable' } }]
  @EndUserText.label: 'Lista de Preço'
  PriceTable : tabname;

}
