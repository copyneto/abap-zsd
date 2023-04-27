@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Lista de Preço'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_INVASAO
  as select from a610 as I_Invasao
  association [1..1] to konp                         as _Monto    on $projection.knumh = _Monto.knumh
{
  key    kappl,
  key    kschl,
  key    pltyp,
  key    werks,
         datab,
         datbi,
         knumh,
         _Monto.konwa,
         @Semantics.amount.currencyCode: 'konwa'
         _Monto.kbetr,
         _Monto.kmein,
         _Monto.kunnr,
         _Monto.loevm_ko 
}
