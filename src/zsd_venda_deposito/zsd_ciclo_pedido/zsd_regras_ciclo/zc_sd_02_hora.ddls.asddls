@EndUserText.label: 'Hora Corte'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['Ziti']
define view entity zc_sd_02_hora
  as projection on zi_sd_02_hora as Hora
{
  key Ziti,
  key Zmed,
      @ObjectModel.text.element: ['Nome']
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_DIAS', element : 'Dias' }}]
  key Zdia,
      @UI.hidden: true
      Nome,
      Zhora,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      /* Associations */
      _Nivel : redirected to parent ZC_SD_01_NIVEL
}
