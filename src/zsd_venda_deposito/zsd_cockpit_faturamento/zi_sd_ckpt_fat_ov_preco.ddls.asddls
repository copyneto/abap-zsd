@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Seleção preço OV'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_FAT_OV_PRECO
  as select from I_SalesOrderItem

{
  key  SalesOrder,
  key  SalesOrderItem,
       SalesOrderCondition,
       OrderQuantityUnit,
       @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
       OrderQuantity

}
where
  OrderQuantity is not initial
