@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ordens Itens Furto Extravio'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_OV_ITEM_FURTO_EXTRAVIO
  as select from I_SalesOrderItem as _SalesOrder
{
  key _SalesOrder.SalesOrder,
  key min( _SalesOrder.SalesOrderItem ) as SalesOrderItem

} group by _SalesOrder.SalesOrder
