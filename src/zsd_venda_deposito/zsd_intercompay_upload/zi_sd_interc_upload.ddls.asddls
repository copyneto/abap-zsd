@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Pedidos intercompany via Excel'
define root view entity ZI_SD_INTERC_UPLOAD
  as select from ztsd_interc_upld
{
  key guid           as Guid,
      werks          as CenterOrigin,
      file_directory as FileDirectory,
      created_date   as CreatedDate,
      created_time   as CreatedTime,
      created_user   as CreatedUser
}
