@AbapCatalog.sqlViewName: 'ZVSD_ORDVAL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ordem de Venda válidas para CDS Cockpit'
define view ZI_SD_COCKPIT_ORD_VALID
  as select from vbak
    inner join   I_SalesOrder as _Order on vbak.vbeln = _Order.SalesOrder
{

  key vgbel      as Contrato,
      max(vbeln) as OrdemVenda

}
where vbtyp                 = 'C'
  and(
       _Order.SalesOrderType = 'Y074'
    or _Order.SalesOrderType = 'Y075'
    or _Order.SalesOrderType = 'Y076'
    or _Order.SalesOrderType = 'Y077'
  )
group by
  vgbel
