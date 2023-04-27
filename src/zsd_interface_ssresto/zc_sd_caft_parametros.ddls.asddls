@EndUserText.label: 'CDS de projeção tabela de parâmetros'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_CAFT_PARAMETROS
  as projection on ZI_SD_CAFT_PARAMETROS
{
  key Id,
  //@Consumption.valueHelpDefinition: [{entity: {name: '', element: 'BusinessPlace' }}]
  key Item,
  //@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_BRANCH', element: 'BusinessPlace' }}]
      Value,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
