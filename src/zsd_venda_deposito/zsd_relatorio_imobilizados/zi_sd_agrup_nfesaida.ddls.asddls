@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Agrupar NFE SAIDA'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_AGRUP_NFESAIDA 
  as select from j_1bnfdoc as _NfSaida
{
         @Search.defaultSearchElement: true
         @Search.ranking: #HIGH
  key    _NfSaida.nfenum as NfeSaida,
         @Search.defaultSearchElement: true
         @Search.ranking: #HIGH
         _NfSaida.docnum as DocnumSaida
}
where
      direct          =  '2'
  and _NfSaida.nfenum <> ' '
  
  group by _NfSaida.nfenum , _NfSaida.docnum 
