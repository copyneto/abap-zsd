@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interf. - Shipping'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_STATUS_SHIP
  as select from I_DeliveryDocument as _Delivery
  association to I_ShippingConditionText as _Shipping on _Shipping.ShippingCondition = $projection.ShippingCondition and _Shipping.Language = 'P'
  //association to tvsbt as _Exped on _Exped.vsbed = $projection.ShippingCondition 
  
{
    key _Delivery.DeliveryDocument as DeliveryDocument,
    _Delivery.ShippingCondition,
    _Delivery.CreationDate         as CreationDateRemessa,
    _Shipping.ShippingConditionName
    
} 
