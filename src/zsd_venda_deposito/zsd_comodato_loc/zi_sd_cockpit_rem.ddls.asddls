@AbapCatalog.sqlViewName: 'ZVSD_REMESSA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Remessa para CDS Cockpit'
define view ZI_SD_COCKPIT_REM
  as select from I_SDDocumentProcessFlow
    inner join   ZI_SD_COCKPIT_REM_VALID as _ValidRem on  _ValidRem.OrdemVenda = I_SDDocumentProcessFlow.PrecedingDocument
                                                      and _ValidRem.Remessa    = I_SDDocumentProcessFlow.SubsequentDocument
  association [0..1] to ZI_SD_COCKPIT_FAT as _Fatura on $projection.Remessa = _Fatura.Remessa
  association [0..1] to ZI_SD_COCKPIT_FRE as _Frete  on $projection.Remessa = _Frete.Remessa
{

  PrecedingDocument      as OrdemVenda,
  SubsequentDocument     as Remessa,
  _Fatura.DocFatura      as DocFatura,
  _Fatura.StatusNfe      as StatusNfe,
  _Fatura.NfeSaida       as NfeSaida,
  _Fatura.DocnumNfeSaida as DocnumNfeSaida,
  _Fatura.DocnumEntrada  as DocnumEntrada,
  _Frete.OrdemFrete      as OrdemFrete

}
where
      PrecedingDocumentCategory  = 'C'
  and SubsequentDocumentCategory = 'J'
