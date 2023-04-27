@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca Remessa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_AGEND_REMESSA_ITEM
  as select from ZI_SD_CICLO_ITEM             as _Remessa
    inner join   ZI_SD_CKPT_AGEND_REMESSA_QTD as _RemessaRef on  _RemessaRef.OutboundDelivery       =  _Remessa.Document
                                                             and _RemessaRef.ReferenceSDDocument    =  _Remessa.SalesOrder
                                                             and _RemessaRef.item                   =  cast( _Remessa.Item as abap.dec(6) )
                                                             and _RemessaRef.ActualDeliveryQuantity <> 0.000
{

  key    _Remessa.SalesOrder,
  key    _Remessa.SalesOrderItem,
  key    _Remessa.Document,
  key    _Remessa.Item,
         _RemessaRef.Material,
         _Remessa.DocNum,
         @Semantics.amount.currencyCode:'Currency'
         _Remessa.Total_Nfe,
         _Remessa.Currency,
         _Remessa.NotaFiscal,
         @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
         sum( _RemessaRef.ItemGrossWeight )         as ItemGrossWeight,
         @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
         sum(  _RemessaRef.ItemNetWeight )          as ItemNetWeight,
         _RemessaRef.ItemWeightUnit,
         _RemessaRef.DeliveryDocumentItemText,
         @Semantics.quantity.unitOfMeasure: 'ItemVolumeUnit'
         sum(  _RemessaRef.ItemVolume )             as ItemVolume,
         _RemessaRef.ItemVolumeUnit,
         @ObjectModel.foreignKey.association: '_DeliveryQuantityUnit'
         _RemessaRef.DeliveryQuantityUnit,
         @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
         sum(  _RemessaRef.ActualDeliveryQuantity ) as ActualDeliveryQuantity
}
group by
  _Remessa.SalesOrder,
  _Remessa.SalesOrderItem,
  _Remessa.Document,
  _Remessa.Item,
  _RemessaRef.Material,
  _Remessa.DocNum,
  _Remessa.Total_Nfe,
  _Remessa.Currency,
  _Remessa.NotaFiscal,
  _RemessaRef.ItemWeightUnit,
  _RemessaRef.DeliveryDocumentItemText,
  _RemessaRef.ItemVolumeUnit,
  _RemessaRef.DeliveryQuantityUnit
