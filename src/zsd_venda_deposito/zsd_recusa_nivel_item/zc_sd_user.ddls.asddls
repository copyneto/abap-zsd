@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Recusa a Nível Item'

define root view entity ZC_SD_USER
  as select from ZTB_SD_RANK

{
  key objectid,
  key username,
      udate,
      utime
}
group by 
  objectid,
  username,
  udate,
  utime
