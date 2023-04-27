@EndUserText.label: 'CDS de projeção - Tipo de condição de pgmt.'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_CAFT_TPCOND
  as projection on ZI_SD_CAFT_TPCOND
{
  //@Consumption.valueHelpDefinition: [{entity: {name: 'SK', element: 'BusinessPlace' }}]
  key Tipopag,
  //@Consumption.valueHelpDefinition: [{entity: {name: '', element: 'BusinessPlace' }}]
      Texto,
  //@Consumption.valueHelpDefinition: [{entity: {name: 'sakombukr', element: 'saknrv' }}]
      Saknr,
  //@Consumption.valueHelpDefinition: [{entity: {name: '', element: 'BusinessPlace' }}]
      Prefixo,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
