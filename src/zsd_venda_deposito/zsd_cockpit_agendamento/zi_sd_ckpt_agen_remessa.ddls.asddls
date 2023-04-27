@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca Remessa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_AGEN_REMESSA
  as select from ZI_SD_CICLO( p_tipo : 'J') as _Remessa
    left outer to one join   I_DeliveryDocumentItem     as _RemessaRef on  _RemessaRef.DeliveryDocument     = _Remessa.Document
                                                           and _RemessaRef.ReferenceSDDocument  = _Remessa.SalesOrder
                                                           and _RemessaRef.DeliveryDocumentItem = _Remessa.Item
{

  key _Remessa.SalesOrder,
  key _Remessa.Document,
      _Remessa.Item,
      _RemessaRef.Material,
      _Remessa.DocNum,
      @Semantics.amount.currencyCode:'Currency'
      _Remessa.Total_Nfe,
      _Remessa.Currency,
      _Remessa.NotaFiscal,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      _RemessaRef.ItemGrossWeight,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      _RemessaRef.ItemNetWeight,
      _RemessaRef.ItemWeightUnit,
      _RemessaRef.DeliveryDocumentItemText,
      @Semantics.quantity.unitOfMeasure: 'ItemVolumeUnit'
      _RemessaRef.ItemVolume,
      _RemessaRef.ItemVolumeUnit,
      @ObjectModel.foreignKey.association: '_DeliveryQuantityUnit'
      _RemessaRef.DeliveryQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
      _RemessaRef.OriginalDeliveryQuantity



}
