@AbapCatalog.sqlViewName: 'ZISD_OV_DEV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help Ordem do Cliente'
@Metadata.allowExtensions: true
@Search.searchable: true
define view ZI_SD_VH_ORDEM_DEV
  as select from I_SalesDocument       as SalesOrder
    inner join   ZI_SD_PARAM_TP_OV_DEV as _TipoOrdem on _TipoOrdem.TpOrdem = SalesOrder.SalesDocumentType

{
      @Search.defaultSearchElement: true
  key SalesDocument as Ordem


}
