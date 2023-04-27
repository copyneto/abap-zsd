@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Lista de Preço'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_LISTA_DE_PRECO
  as select from ZI_SD_GESTAO_PRECO_LISTA_PRECO as I_Lista
  association [1..1] to konp as _Monto  on $projection.knumh = _Monto.knumh
  association [1..1] to konm as _Escala on $projection.knumh = _Escala.knumh
{
  key    kappl,
  key    kschl,
  key    vtweg,
  key    pltyp,
  key    werks,
  key    matnr,
         datab,
         datbi,
         knumh,
         case
         when _Escala.kstbm is null
         then  cast( _Monto.kstbm as abap.dec( 15,3 ))
         else  cast( _Escala.kstbm as abap.dec( 15,3 ))
         end as kstbm,

         _Monto.konwa,
         @Semantics.amount.currencyCode: 'konwa'
         case
         when _Escala.kbetr is null
         then  cast( _Monto.kbetr as abap.dec(11,2))
         else  cast( _Escala.kbetr as abap.dec(11,2))
         end as kbetr,
         _Monto.kmein,
         @Semantics.amount.currencyCode: 'konwa'
         _Monto.mxwrt,
         @Semantics.amount.currencyCode: 'konwa'
         _Monto.gkwrt,
         _Monto.loevm_ko,
         _Escala.kopos,
         _Escala.klfn1

}
where
      kappl is not initial
  and kschl is not initial

