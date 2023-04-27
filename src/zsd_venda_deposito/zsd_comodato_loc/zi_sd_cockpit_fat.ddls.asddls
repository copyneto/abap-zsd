@AbapCatalog.sqlViewName: 'ZVSD_DOCFAT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Doc. Faturamento para CDS Cockpit'
define view ZI_SD_COCKPIT_FAT
  as select from    I_SDDocumentProcessFlow as Flow

  inner join ZI_SD_COCKPIT_FAT_VALID      as _ValidFat on _ValidFat.Remessa = Flow.PrecedingDocument 
                                                      and _ValidFat.DocFatura = Flow.SubsequentDocument
  left outer join I_BR_NFItem             as _Ent on  _Ent.BR_NFSourceDocumentNumber = Flow.SubsequentDocument
                                                    

  association [0..1] to ZI_SD_COCKPIT_NF as _NF on $projection.DocFatura = _NF.DocFatura
  //  association [0..1] to ZI_SD_COCKPIT_NFENT2 as _Ent on $projection.DocFatura = _Ent.DocFatura

{

  PrecedingDocument  as Remessa,
  SubsequentDocument as DocFatura,
  _NF.StatusNfe      as StatusNfe,
  _NF.NfeSaida       as NfeSaida,
  _NF.DocnumNfeSaida as DocnumNfeSaida,
  //  _Ent.DocnumEntrada as DocnumEntrada
  _Ent.BR_NotaFiscal as DocnumEntrada

}
where
      PrecedingDocumentCategory  = 'J'
  and SubsequentDocumentCategory = 'M'
