@AbapCatalog.sqlViewName: 'ZVSD_MONECOITEM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Monitor E-Commerce - Itens não recusados'
define view ZI_SD_MONITOR_ITEM
  as select distinct from I_SalesOrderItem
{
  key SalesOrder,
  key SalesOrderItem

}
where
  SalesDocumentRjcnReason is not initial
