@AbapCatalog.sqlViewName: 'ZVSDFLOWCONTRATO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Fluxo Contrato'
define view ZI_SD_CONTR_LOC_COM_FLOW
  with parameters
    p_tipo : vbtyp_n
  as select distinct from vbfa        as _flow
    left outer join       vbak        as _SalesOrder on  _SalesOrder.vbeln = _flow.vbeln
                                                     and _SalesOrder.vbtyp = _flow.vbtyp_n
    left outer join       I_BR_NFItem as _NFITEM     on  _NFITEM.BR_NFSourceDocumentType   = 'BI'
                                                     and _NFITEM.BR_NFSourceDocumentNumber = _flow.vbeln
    
    left outer join I_SalesOrderItem as _OrderItem on  _flow.vbeln = _OrderItem.SalesOrder
                                                   and _flow.posnn = _OrderItem.SalesOrderItem    
    
    association to I_BR_NFDocument as _NFDOCUMENT on _NFDOCUMENT.BR_NotaFiscal = _NFITEM.BR_NotaFiscal
  
  
{

  key _flow.vbelv                                                                as SalesContract,    
  key  _flow.posnv                                                               as Item,
      _flow.vbeln                                                                as Document,          
      _SalesOrder.waerk                                                          as Moeda,
      @Semantics.amount.currencyCode : 'Moeda'
      _SalesOrder.netwr                                                          as ValorAluguel,
      @Semantics.amount.currencyCode : 'Moeda'
      _OrderItem.NetAmount,
      _NFITEM.BR_NotaFiscal                                                      as DocNum,
      concat( _NFDOCUMENT.BR_NFeNumber, concat( '-', _NFDOCUMENT.BR_NFSeries ) ) as NotaFiscal

}
where
  vbtyp_n = $parameters.p_tipo
