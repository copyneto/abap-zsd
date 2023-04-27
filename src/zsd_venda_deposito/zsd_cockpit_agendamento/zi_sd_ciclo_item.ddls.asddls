@AbapCatalog.sqlViewName: 'ZVSDCICLOI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ciclo Ordem'
define view ZI_SD_CICLO_ITEM
  as select distinct from    vbfa        as _flow

    left outer join I_BR_NFItem as _NFITEM on  _NFITEM.BR_NFSourceDocumentType   = 'BI'
                                           and _NFITEM.BR_NFSourceDocumentNumber = _flow.vbeln
                                           and _NFITEM.BR_NotaFiscalItem         = _flow.posnn

  association to I_BR_NFDocument as _NFDOCUMENT on  _NFDOCUMENT.BR_NotaFiscal   =  _NFITEM.BR_NotaFiscal
                                                and _NFDOCUMENT.BR_NFIsCanceled <> 'X'
{

  key _flow.vbelv                   as SalesOrder,
      _flow.posnv                   as SalesOrderItem,
      _flow.vbeln                   as Document,
      _flow.posnn                   as Item,
      _NFITEM.BR_NotaFiscal         as DocNum,
      _NFITEM.BR_NFTotalAmount      as Total_Nfe,
      _NFITEM.SalesDocumentCurrency as Currency,

      case
      when _NFDOCUMENT.BR_NFSeries = ''
      then _NFDOCUMENT.BR_NFeNumber
      else
            concat( _NFDOCUMENT.BR_NFeNumber, concat( '-', _NFDOCUMENT.BR_NFSeries ) )
      end                           as NotaFiscal,

      _NFDOCUMENT.BR_NFTotalAmount  as Total_Nfe_Header
}
where
  _flow.vbtyp_n = 'J'
