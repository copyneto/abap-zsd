@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Valores Pendentes OV Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #L,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_FAT_VLR_PEND_OV_I
  as select from ZI_SD_CKPT_FAT_QTD_PEND as _QtdPendete
  association to ZI_SD_CKPT_FAT_PRECO_UNIT as _PrecoUnit on  _PrecoUnit.SalesOrder     = _QtdPendete.SalesOrder
                                                         and _PrecoUnit.SalesOrderItem = _QtdPendete.SalesOrderItem


{
  key  _QtdPendete.SalesOrder,
  key  _QtdPendete.SalesOrderItem,
       _QtdPendete.OrderQuantityUnit,
       @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
       _QtdPendete.QtdPendete,
       _PrecoUnit.waerk,
       @Semantics.amount.currencyCode : 'waerk'
       _PrecoUnit.PrecoUnit,
       cast( _QtdPendete.QtdPendete  * _PrecoUnit.PrecoUnit as abap.dec( 15, 2 )) as VlrPendItem
}
