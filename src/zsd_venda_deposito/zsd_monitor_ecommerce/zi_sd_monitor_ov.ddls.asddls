@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Monitor E-commerce Ordem de venda'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_MONITOR_OV
  as select from I_SalesOrder as SalesOrder
  association to I_SalesOrderItem as _SalesItem
    on _SalesItem.SalesOrder = $projection.SalesOrder
{
  SalesOrder,
  SalesOrderType,
  _SalesItem.Plant,
  OverallSDDocumentRejectionSts,
  PurchaseOrderByCustomer,
  CreationDate,
  DistributionChannel,
  CreationTime,
  DeliveryBlockReason
}

group by
  SalesOrder,
  SalesOrderType,
  _SalesItem.Plant,
  OverallSDDocumentRejectionSts,
  PurchaseOrderByCustomer,
  CreationDate,
  DistributionChannel,
  CreationTime,
  DeliveryBlockReason
