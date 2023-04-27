@AbapCatalog.sqlViewName: 'ZVSDCENTROITM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Centro item'
define view ZI_SD_CENTRO_ITEM
  as select distinct from vbap
{
    key vbeln,
        werks

  }
