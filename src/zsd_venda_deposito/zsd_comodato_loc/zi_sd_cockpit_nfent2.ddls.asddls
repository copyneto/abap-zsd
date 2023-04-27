@AbapCatalog.sqlViewName: 'ZVSD_NFENT2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'NF Ent. para CDS Cockpit'
define view ZI_SD_COCKPIT_NFENT2
  as select from ZI_SD_COCKPIT_NFENT
  association [0..1] to I_BR_NFItem as _Item on  $projection.DocMat            = _Item.BR_ReferenceNFNumber
                                             and _Item.BR_NFSourceDocumentType = 'MD'
{
  key DocFatura,
      DocMat,
      _Item.BR_NotaFiscal as DocnumEntrada

}
