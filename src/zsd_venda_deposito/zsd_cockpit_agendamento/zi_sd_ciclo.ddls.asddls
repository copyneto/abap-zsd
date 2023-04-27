@AbapCatalog.sqlViewName: 'ZVSDCICLO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ciclo Ordem'
define view ZI_SD_CICLO
  with parameters
    p_tipo : vbtyp_n
  as select distinct from vbfa        as _flow

    left outer join       I_BR_NFItem as _NFITEM on  _NFITEM.BR_NFSourceDocumentType   = 'BI'
                                                 and _NFITEM.BR_NFSourceDocumentNumber = _flow.vbeln
                                                 and _NFITEM.BR_NotaFiscalItem         = _flow.posnn

  association to I_BR_NFDocument as _NFDOCUMENT on  _NFDOCUMENT.BR_NotaFiscal   =  _NFITEM.BR_NotaFiscal
                                                and _NFDOCUMENT.BR_NFIsCanceled <> 'X'
{

  key _flow.vbelv                   as SalesOrder,
      _flow.vbeln                   as Document,
      case
      when _flow.posnn >= '900000'
      then _flow.posnv
      else _flow.posnn
      end                           as Item,
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
  vbtyp_n = $parameters.p_tipo
