@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Ordem de Venda - Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_OV_ITEM
  as select from I_SalesOrderItem as _SalesOrderItem

{
  key  _SalesOrderItem.SalesOrder              as SalesOrder,
       min( _SalesOrderItem.SalesOrderItem )   as SalesOrderItem,
       _SalesOrderItem.Plant                   as Plant,
       _SalesOrderItem.ShippingPoint           as ShippingPoint
////       _SalesOrderItem.SalesDocumentRjcnReason as SalesDocumentRjcnReason
}
group by
  _SalesOrderItem.SalesOrder,
  _SalesOrderItem.Plant,
  _SalesOrderItem.ShippingPoint
////  _SalesOrderItem.SalesDocumentRjcnReason
