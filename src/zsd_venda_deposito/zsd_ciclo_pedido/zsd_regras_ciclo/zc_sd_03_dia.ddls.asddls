@EndUserText.label: 'Dias de Faturamento'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['Ziti']
define view entity ZC_SD_03_DIA
  as projection on zi_sd_03_dia as Dia
{
  key Ziti,
  key Zmed,
      @ObjectModel.text.element: ['Nome']
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZC_SD_VH_DIAE', element : 'Dias' }}]
  key Zdia,
      @UI.hidden: true
      Nome,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      /* Associations */
      _Nivel : redirected to parent ZC_SD_01_NIVEL
}
