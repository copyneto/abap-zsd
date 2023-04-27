@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Minimo Item da Remessa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_AGEND_ENTREGA_MIN 
as select from       ZI_SD_AGEN_ENTREGA

{
 key SalesOrder,
     Remessa,
     min( SalesOrderItem ) as SalesOrderItem
}
group by SalesOrder, Remessa
