@AbapCatalog.sqlViewName: 'ZVSD_NFSAIDA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Match code'
define view ZI_SD_VH_NFESAIDA
  as select distinct from ZI_SD_AGRUP_NFESAIDA as _NfSaida
{
         @Search.defaultSearchElement: true
         @Search.ranking: #HIGH
  key    NfeSaida,
         @Search.defaultSearchElement: true
         @Search.ranking: #HIGH
  key    DocnumSaida

}
