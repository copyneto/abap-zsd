@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS agrupar itens'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #L,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_FAT_AGRUPA_ITEM 
as select from I_SalesOrderItem   
{
  key SalesOrder,      
  min(SalesOrderItem) as SalesOrderItem
}
where I_SalesOrderItem.SalesDocumentRjcnReason is initial
group by SalesOrder

