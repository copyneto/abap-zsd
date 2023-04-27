@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Remessa devolução App ecommerce'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REMESSA_DEV
  as select from I_SDDocumentMultiLevelProcFlow as Remessa
  association to I_SalesOrder       as _SalesOrd  on _SalesOrd.SalesOrder = $projection.SubsequentDocument
  association to I_DeliveryDocument as _Delivery  on _Delivery.DeliveryDocument = $projection.SubsequentDocument
  association to ZI_SD_FATURA_DEV   as _Faturadev on _Faturadev.PrecedingDocument = $projection.SubsequentDocument

{
  Remessa.PrecedingDocument,
  Remessa.SubsequentDocumentCategory,
  Remessa.SubsequentDocument,
  _SalesOrd.CreationDate,
  _SalesOrd.CreationTime,
  _Delivery.ShippingPoint       as ShippingPoint,
  _Delivery.OverallGoodsMovementStatus,
  _Faturadev.PrecedingDocument  as Remessa,
  _Faturadev.SubsequentDocument as FaturaDev,
  _Faturadev.SubsequentDocument as FaturaVend,
  _Faturadev.BR_NFeNumber,
  _Faturadev.BR_NotaFiscal,
  _Faturadev.BR_NFPartnerRegionCode,
  _Faturadev.SalesDocumentCurrency,
  @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
  _Faturadev.BR_NFTotalAmount,
  _Faturadev.BR_NFeDocumentStatus

}
where
  SubsequentDocumentCategory = 'T' //'J'
group by
  Remessa.PrecedingDocument,
  Remessa.SubsequentDocumentCategory,
  Remessa.SubsequentDocument,
  _SalesOrd.CreationDate,
  _SalesOrd.CreationTime,
  _Delivery.ShippingPoint,
  _Delivery.OverallGoodsMovementStatus,
  _Faturadev.PrecedingDocument,
  _Faturadev.SubsequentDocument,
  _Faturadev.BR_NFeNumber,
  _Faturadev.BR_NotaFiscal,
  _Faturadev.BR_NFPartnerRegionCode,
  _Faturadev.SalesDocumentCurrency,
  _Faturadev.BR_NFTotalAmount,
  _Faturadev.BR_NFeDocumentStatus
