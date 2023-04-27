@AbapCatalog.sqlViewName: 'ZVSD_ORDFIN'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ordem de Venda válidas para CDS Cockpit'
define view ZI_SD_COCKPIT_ORD_VALID_FINAL as 

select from vbak
   
join ZI_SD_COCKPIT_ORD_VALID as _Order    on vbak.vbeln = _Order.OrdemVenda      

{

  key vgbel as Contrato,     
  _Order.OrdemVenda   
}
where vbtyp = 'C'

union

select from vbak

join I_SalesOrder            as _OrderDev on _OrderDev.SalesOrder            = vbak.vbeln 
                                          and ( _OrderDev.SalesOrderType      =  'YR75'
                                             or _OrderDev.SalesOrderType      =  'YD75'
                                             or _OrderDev.SalesOrderType      =  'YR76'
                                             or _OrderDev.SalesOrderType      =  'YD76'
                                             or _OrderDev.SalesOrderType      =  'YR74'
                                             or _OrderDev.SalesOrderType      =  'YD74'
                                             or _OrderDev.SalesOrderType      =  'YR77'
                                             or _OrderDev.SalesOrderType      =  'YD77')
{

  key vgbel as Contrato,
  _OrderDev.SalesOrder as OrdemVenda
}
where vbtyp = 'C'
