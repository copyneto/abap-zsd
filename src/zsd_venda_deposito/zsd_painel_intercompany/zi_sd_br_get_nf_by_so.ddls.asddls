@AbapCatalog.sqlViewName: 'ZVSDGETNFSO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta fluxo de documentos'
define view ZI_SD_BR_GET_NF_BY_SO
  as select distinct from vbfa      as SDFlow
    inner join            j_1bnflin as _NFItem on  _NFItem.refkey = SDFlow.vbeln
                                               and _NFItem.reftyp = 'BI'
    inner join            j_1bnfdoc as _NFDoc  on _NFDoc.docnum = _NFItem.docnum

  association [0..1] to I_BR_NFeDocumentStatusText as _DocStatusText on  _DocStatusText.BR_NFeDocumentStatus = $projection.BR_NFeDocumentStatus
                                                                     and _DocStatusText.Language             = $session.system_language

{
  key _NFDoc.docnum                      as BR_NotaFiscal,
      _NFDoc.nfenum                      as BR_NFeNumber,
      cast( '' as j_1b_purch_order_ext ) as PurchaseOrder,
      SDFlow.vbelv                       as SalesOrder,
      _NFDoc.docstat                     as BR_NFeDocumentStatus,
      _NFDoc.direct                      as Direction,
      _DocStatusText.BR_NFeDocumentStatusDesc
}
where
      SDFlow.vbtyp_n = 'M'
  and _NFDoc.doctyp  = '1'
  and _NFDoc.cancel  = ' '
