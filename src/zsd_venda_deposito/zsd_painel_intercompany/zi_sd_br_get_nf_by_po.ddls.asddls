@AbapCatalog.sqlViewName: 'ZVSDGETNFPO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta fluxo de documentos'
define view ZI_SD_BR_GET_NF_BY_PO
  as select distinct from j_1bnfdoc as NFDoc
    inner join            j_1bnflin as _NFItem on _NFItem.docnum = NFDoc.docnum
    inner join            ekko      as _PO     on _PO.ebeln = _NFItem.xped

  association [0..1] to I_BR_NFeDocumentStatusText     as _DocStatusText       on  _DocStatusText.BR_NFeDocumentStatus = $projection.BR_NFeDocumentStatus
                                                                               and _DocStatusText.Language             = $session.system_language

{
  key NFDoc.docnum        as BR_NotaFiscal,
      NFDoc.nfenum        as BR_NFeNumber,
      NFDoc.nftype        as BR_NFType,
      _NFItem.xped        as PurchaseOrder,
      cast( '' as vbeln ) as SalesOrder,
      NFDoc.docstat       as BR_NFeDocumentStatus,
      NFDoc.direct        as Direction,
      _DocStatusText.BR_NFeDocumentStatusDesc
}
where
  (
       NFDoc.doctyp = '1'
    or NFDoc.doctyp = '6'
  )
  and  NFDoc.cancel = ''
