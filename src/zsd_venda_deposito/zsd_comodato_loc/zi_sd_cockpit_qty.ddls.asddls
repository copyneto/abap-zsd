@AbapCatalog.sqlViewName: 'ZVSD_QTY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Quant. Itens Atual para CDS Cockpit'
define view ZI_SD_COCKPIT_QTY
  as select from I_SalesOrderItem
{
  SalesOrder as Contrato,
  count(*)   as QtdItens
}
where
  SalesDocumentRjcnReason is initial
group by
  SalesOrder
