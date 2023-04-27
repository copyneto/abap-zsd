@AbapCatalog.sqlViewName: 'ZVSD_NF'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'NF para CDS Cockpit'
define view ZI_SD_COCKPIT_NF
  as select from I_BR_NFItem
  association [0..1] to I_BR_NFDocument as _Header on $projection.DocnumNfeSaida = _Header.BR_NotaFiscal
{
  BR_NotaFiscal                as DocnumNfeSaida,
  BR_NFSourceDocumentNumber    as DocFatura,
  //BR_ReferenceNFNumber         as DocFatura,
  _Header.BR_NFeDocumentStatus as StatusNfe,
  _Header.BR_NFeNumber         as NfeSaida
}
where
  BR_NFSourceDocumentType = 'BI'
