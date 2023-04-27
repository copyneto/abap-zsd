@AbapCatalog.sqlViewName: 'ZVSD_REMVAL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Remessa válidas para CDS Cockpit'
define view ZI_SD_COCKPIT_REM_VALID
  as select from I_SDDocumentProcessFlow
{

  PrecedingDocument       as OrdemVenda,
  max(SubsequentDocument) as Remessa

}
where
      PrecedingDocumentCategory  = 'C'
  and SubsequentDocumentCategory = 'J'
  group by PrecedingDocument
