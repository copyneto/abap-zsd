@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Somatório do peso bruto'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_FAT_PESOBRUTO
  as select from vbap as _salesorderitem
{

  key _salesorderitem.vbeln        as SalesOrder,
//  _salesorderitem.posnr            as SalesOrderItem,
  @DefaultAggregation: #SUM
  @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
  sum( _salesorderitem.brgew ) as ItemGrossWeight,
  _salesorderitem.gewei        as ItemWeightUnit

}
where
  _salesorderitem.abgru = ' '
group by
  vbeln, gewei
