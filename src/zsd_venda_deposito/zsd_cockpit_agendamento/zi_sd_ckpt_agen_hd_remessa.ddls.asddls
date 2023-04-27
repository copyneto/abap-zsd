@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS busca remessa mínima'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_AGEN_HD_REMESSA
  as select from           ZI_SD_CKPT_AGEN_REMESSA  as _Remessa
    inner join             ZI_SD_CKPT_AGEND_MIN_REM as _Min        on  _Min.SalesOrder = _Remessa.SalesOrder
                                                                   and _Min.Document   = _Remessa.Document

  //    left outer to one join I_OutboundDeliveryItem   as _RemessaRef on  _RemessaRef.OutboundDelivery    = _Remessa.Document
  //                                                                   and _RemessaRef.ReferenceSDDocument = _Remessa.SalesOrder
  //                                                                  and _RemessaRef.OutboundDeliveryItem = teste.Item
    left outer to one join I_OutboundDelivery       as _RemessaRef on _RemessaRef.OutboundDelivery = _Remessa.Document
  //                                                                   and _RemessaRef.ReferenceSDDocument = _Remessa.SalesOrder
{

  key _Remessa.SalesOrder,
  key _Remessa.Document,
      _Remessa.NotaFiscal,
      //      teste.Item,
      //      @Semantics.quantity.unitOfMeasure: 'ItemVolumeUnit'
      //      sum(_RemessaRef.ItemVolume) as ItemVolume,
      //      _RemessaRef.ItemVolumeUnit
      @Semantics.quantity.unitOfMeasure: 'ItemVolumeUnit'
      _RemessaRef.HeaderVolume     as ItemVolume,
      _RemessaRef.HeaderVolumeUnit as ItemVolumeUnit,
      @Semantics.quantity.unitOfMeasure: 'HeaderWeightUnit'
      _RemessaRef.HeaderGrossWeight,
      @Semantics.quantity.unitOfMeasure: 'HeaderWeightUnit'
      _RemessaRef.HeaderNetWeight,
      _RemessaRef.HeaderWeightUnit


}
where
  _Remessa.Document is not initial
group by
  _Remessa.SalesOrder,
  _Remessa.Document,
  //   teste.Item,
  _Remessa.NotaFiscal,
  _RemessaRef.HeaderVolume,
  _RemessaRef.HeaderVolumeUnit,
  _RemessaRef.HeaderGrossWeight,
  _RemessaRef.HeaderNetWeight,
  _RemessaRef.HeaderWeightUnit
