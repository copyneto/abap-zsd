@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca Item minimo da ordem'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_AGEN_MIN_ITEM 
as select from I_SalesOrderItem  {
    key SalesOrder,
    min( SalesOrderItem ) as SalesOrderItem
} group by SalesOrder
