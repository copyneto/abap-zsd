@AbapCatalog.sqlViewName: 'ZVSD_ORDEM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ordem de Venda para CDS Cockpit'
define view ZI_SD_COCKPIT_ORD
  //  as select from I_SDDocumentProcessFlow
  //  association [0..1] to I_SalesOrder      as _Order   on $projection.OrdemVenda = _Order.SalesOrder
  //  association [0..1] to ZI_SD_COCKPIT_REM as _FlowRem on $projection.OrdemVenda = _FlowRem.OrdemVenda
  //{
  //
  //  key PrecedingDocument       as Contrato,
  //  key SubsequentDocument      as OrdemVenda,
  //  key _FlowRem.DocFatura      as DocFatura,
  //      _Order.SalesOrderType   as TipoOrdemVenda,
  //      _FlowRem.Remessa        as Remessa,
  ////      _FlowRem.DocFatura      as DocFatura,
  //      _FlowRem.StatusNfe      as StatusNfe,
  //      _FlowRem.NfeSaida       as NfeSaida,
  //      _FlowRem.DocnumNfeSaida as DocnumNfeSaida,
  //      _FlowRem.DocnumEntrada  as DocnumEntrada,
  //      _FlowRem.OrdemFrete     as OrdemFrete,
  //
  //      _FlowRem,
  //      _Order
  //
  //}
  //where
  //      PrecedingDocumentCategory  = 'G'
  //  and SubsequentDocumentCategory = 'C'
  //  and SubsequentDocumentItem     <> '000000'
  //  and
  //  (
  //       _Order.SalesOrderType =  'Y075'
  //    or _Order.SalesOrderType =  'Y074'
  //    or _Order.SalesOrderType =  'Y076'
  //    or _Order.SalesOrderType =  'Y077'
  //    or _Order.SalesOrderType =  'YR75'
  //    or _Order.SalesOrderType =  'YD75'
  //    or _Order.SalesOrderType =  'YR76'
  //    or _Order.SalesOrderType =  'YD76'
  //    or _Order.SalesOrderType =  'YR74'
  //    or _Order.SalesOrderType =  'YD74'
  //    or _Order.SalesOrderType =  'YR77'
  //    or _Order.SalesOrderType =  'YD77'
  //  )
  //  and  _Order.SalesOrderType <> 'Z011'
  as select from vbak
    inner join   ZI_SD_COCKPIT_ORD_VALID_FINAL as _ValidOrder on  _ValidOrder.Contrato   = vbak.vgbel
                                                              and _ValidOrder.OrdemVenda = vbak.vbeln
  association [0..1] to I_SalesOrder      as _Order   on $projection.OrdemVenda = _Order.SalesOrder
  association [0..1] to ZI_SD_COCKPIT_REM as _FlowRem on $projection.OrdemVenda = _FlowRem.OrdemVenda
{

  key vgbel                        as Contrato,
  key vbeln                        as OrdemVenda,
  key _FlowRem.DocFatura           as DocFatura,
      max(_Order.SalesOrderType)   as TipoOrdemVenda,
      max(_FlowRem.Remessa)        as Remessa,
      //      _FlowRem.DocFatura      as DocFatura,
      max(_FlowRem.StatusNfe)      as StatusNfe,
      max(_FlowRem.NfeSaida)       as NfeSaida,
      max(_FlowRem.DocnumNfeSaida) as DocnumNfeSaida,
      max(_FlowRem.DocnumEntrada)  as DocnumEntrada,
      max(_FlowRem.OrdemFrete)     as OrdemFrete,
      _FlowRem,
      _Order

}
where
       vbtyp                 =  'C'
  and(
       _Order.SalesOrderType =  'Y075'
    or _Order.SalesOrderType =  'Y074'
    or _Order.SalesOrderType =  'Y076'
    or _Order.SalesOrderType =  'Y077'
    or _Order.SalesOrderType =  'YR75'
    or _Order.SalesOrderType =  'YD75'
    or _Order.SalesOrderType =  'YR76'
    or _Order.SalesOrderType =  'YD76'
    or _Order.SalesOrderType =  'YR74'
    or _Order.SalesOrderType =  'YD74'
    or _Order.SalesOrderType =  'YR77'
    or _Order.SalesOrderType =  'YD77'
  )
  and  _Order.SalesOrderType <> 'Z011'
group by
  vgbel,
  vbeln,
  _FlowRem.DocFatura
