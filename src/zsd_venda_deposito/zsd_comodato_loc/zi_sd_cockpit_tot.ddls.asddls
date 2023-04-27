@AbapCatalog.sqlViewName: 'ZVSD_TOT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Quant. Itens Total para CDS Cockpit'
define view ZI_SD_COCKPIT_TOT
  as select from I_SalesOrderItem
{
  SalesOrder as Contrato,
  count(*)   as QtdTotal
}
group by
  SalesOrder
