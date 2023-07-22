@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Seleção VBEP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_FAT_OV_QTD
  as select from vbep
{
  key vbeln,
  key posnr,
      vrkme,
      @Semantics.quantity.unitOfMeasure: 'vrkme'
      ordqty_su
} 
where ordqty_su is not initial
