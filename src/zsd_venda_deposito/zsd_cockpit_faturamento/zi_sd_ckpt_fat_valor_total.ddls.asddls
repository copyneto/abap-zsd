@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Seleciona Valor Total'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_FAT_VALOR_TOTAL
  as select from ZI_SD_CKPT_FAT_PRECO as _Preco
{
  key  _Preco.knumv,
       _Preco.waerk,
       @Semantics.amount.currencyCode : 'waerk'
       sum( _Preco.kwert ) as ValorTotal
}
group by
  _Preco.knumv,
  _Preco.waerk
