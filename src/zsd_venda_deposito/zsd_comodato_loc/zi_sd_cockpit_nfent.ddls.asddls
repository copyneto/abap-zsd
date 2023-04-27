@AbapCatalog.sqlViewName: 'ZVSD_NFENT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'NF Ent. para CDS Cockpit'
define view ZI_SD_COCKPIT_NFENT
  as select from mkpf
{
  key  mblnr,
  key  mjahr,
       xabln                as DocFatura,
       concat(mblnr, mjahr) as DocMat

}
