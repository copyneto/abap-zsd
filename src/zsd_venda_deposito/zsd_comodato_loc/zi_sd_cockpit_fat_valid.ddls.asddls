@AbapCatalog.sqlViewName: 'ZVSD_FATVAL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Doc. Faturamento para CDS Cockpit'
define view ZI_SD_COCKPIT_FAT_VALID
  as select from    I_SDDocumentProcessFlow as Flow

{

  PrecedingDocument  as Remessa,
 max( SubsequentDocument ) as DocFatura

}
where
      PrecedingDocumentCategory  = 'J'
  and SubsequentDocumentCategory = 'M'
  group by PrecedingDocument
