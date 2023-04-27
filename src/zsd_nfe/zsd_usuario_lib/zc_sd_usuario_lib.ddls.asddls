@EndUserText.label: 'Usuários de Liberação'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_USUARIO_LIB 
as projection on ZI_SD_USUARIO_LIB
{
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_USER', element: 'Bname' }}]
  key Usuario,
  key Programa,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
