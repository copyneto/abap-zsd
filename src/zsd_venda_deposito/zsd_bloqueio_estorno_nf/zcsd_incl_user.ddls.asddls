@EndUserText.label: 'incl user autor. estor. NF fora compet.'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZcSD_INCL_USER
  as projection on ZI_SD_INCL_USER
{
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_USER', element: 'Bname' }}]
  key Usuario,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
