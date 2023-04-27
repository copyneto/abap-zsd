@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca Remessa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_AGEND_REMESSA_QTD
  as select from I_OutboundDeliveryItem
{

  key    OutboundDelivery, 
  key    ReferenceSDDocument,
  key    sum( cast( HigherLvlItmOfBatSpltItm as abap.dec( 6 ) ) ) as HigherLvlItmOfBatSpltItm,
  key    sum( case
         when HigherLvlItmOfBatSpltItm = '000000'
         then cast( OutboundDeliveryItem as abap.dec( 6 ) )
         else cast( HigherLvlItmOfBatSpltItm as abap.dec( 6 ) )
         end                           )                          as item,  
         Material,
         @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
         sum( ItemGrossWeight )                                   as ItemGrossWeight,
         @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
         sum( ItemNetWeight )                                     as ItemNetWeight,
         ItemWeightUnit,
         DeliveryDocumentItemText,
         @Semantics.quantity.unitOfMeasure: 'ItemVolumeUnit'
         sum( ItemVolume )                                        as ItemVolume,
         ItemVolumeUnit,
         @ObjectModel.foreignKey.association: '_DeliveryQuantityUnit'
         DeliveryQuantityUnit,
         @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
         sum( ActualDeliveryQuantity )                            as ActualDeliveryQuantity 

}
where
  ActualDeliveryQuantity <> 0.000
group by
  OutboundDelivery,
  ReferenceSDDocument,
  HigherLvlItmOfBatSpltItm,
  OutboundDeliveryItem,
  Material,
  ItemWeightUnit,
  DeliveryDocumentItemText,
  ItemVolumeUnit,
  DeliveryQuantityUnit
