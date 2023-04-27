@AbapCatalog.sqlViewName: 'ZVSDGETFLOW'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta fluxo de documentos'
define view ZI_SD_CKPT_CICLO_PED_FLOW
with parameters 
    p_tipo : vbtyp_n
  as select distinct from vbfa as _flow
  left outer join I_BR_NFItem as _NFITEM on _NFITEM.BR_NFSourceDocumentType = 'BI'
                                        and _NFITEM.BR_NFSourceDocumentNumber  = _flow.vbeln
  association to I_BR_NFDocument as _NFDOCUMENT on  _NFDOCUMENT.BR_NotaFiscal = _NFITEM.BR_NotaFiscal
{

  key _flow.vbelv as SalesOrder,
      _flow.vbeln as Document,
      _NFITEM.BR_NotaFiscal as DocNum,
      concat( _NFDOCUMENT.BR_NFeNumber, concat( '-', _NFDOCUMENT.BR_NFSeries ) ) as NotaFiscal
 
} where vbtyp_n = $parameters.p_tipo
