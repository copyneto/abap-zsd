@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Calcula peso ordem'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_KIT_BON_ORDER_PESO
  as select from I_SalesOrderItem
{
  key SalesOrder,
      ItemWeightUnit,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      sum( ItemGrossWeight ) as HeaderGrossWeight,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      sum( ItemNetWeight )   as HeaderNetWeight
}
where
  SalesDocumentRjcnReason = ''
group by
  ItemWeightUnit,
  SalesOrder
