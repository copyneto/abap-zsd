@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Valores Pendentes OV'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_FAT_QTD_PEND
  as select from I_SalesOrderItem as _Item
//  association to I_SalesDocumentScheduleLine as _ScheduleLine on  _ScheduleLine.SalesDocument     = _Item.SalesOrder
//                                                              and _ScheduleLine.SalesDocumentItem = _Item.SalesOrderItem
inner join ZI_SD_CKPT_FAT_OV_QTD  as _ScheduleLine on _ScheduleLine.vbeln = _Item.SalesOrder
                                                  and _ScheduleLine.posnr = _Item.SalesOrderItem

{
  key  _Item.SalesOrder,
  key  _Item.SalesOrderItem,
//       _ScheduleLine.OrderQuantityUnit,
       _ScheduleLine.vrkme as OrderQuantityUnit,
       @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
//       sum( cast( _ScheduleLine.OpenReqdDelivQtyInOrdQtyUnit as abap.dec(13,3)) ) as QtdPendete
       sum( cast( _ScheduleLine.ordqty_su as abap.dec(13,3)) ) as QtdPendete
}
where
  _Item.SalesDocumentRjcnReason = ''
group by
  _Item.SalesOrder,
  _Item.SalesOrderItem,
//  _ScheduleLine.OrderQuantityUnit
_ScheduleLine.vrkme
