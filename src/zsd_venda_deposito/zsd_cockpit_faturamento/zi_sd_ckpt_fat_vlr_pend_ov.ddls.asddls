@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Valores Pendentes OV'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_FAT_VLR_PEND_OV
  as select from ZI_SD_CKPT_FAT_VLR_PEND_OV_I as _Item

{
  key  _Item.SalesOrder,
       //       sum( cast(  _Item.VlrPendItem as abap.dec(28,2) ) ) as VlrPendOV
       _Item.waerk,
       @Semantics.amount.currencyCode : 'waerk'
       sum( cast(  _Item.VlrPendItem as abap.curr(28,2) ) ) as VlrPendOV
}
group by
  _Item.SalesOrder,
  _Item.waerk
