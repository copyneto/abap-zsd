@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Fatura de devoluçao App ecommerce'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_FATURA_DEV
  as select from I_SDDocumentProcessFlow as _Fatura
  inner join I_BillingDocument as _Estorno on _Estorno.BillingDocument = _Fatura.SubsequentDocument
  association to ZI_SD_MONITOR_NF as _Nf on _Nf.BR_NFSourceDocumentNumber = $projection.SubsequentDocument

{
  _Fatura.PrecedingDocument,
  _Fatura.SubsequentDocumentCategory,
  _Fatura.SubsequentDocument,
  _Nf.BR_NFeNumber,
  _Nf.BR_NotaFiscal,
  _Nf.BR_NFPartnerRegionCode,
  _Nf.SalesDocumentCurrency,
  @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
  _Nf.BR_NFTotalAmount,
  _Nf.BR_NFeDocumentStatus
}
where
  (_Fatura.SubsequentDocumentCategory = 'O' or 
  _Fatura.SubsequentDocumentCategory = 'M')//'M'
  and _Estorno.BillingDocumentIsCancelled is initial
group by
  _Fatura.PrecedingDocument,
  _Fatura.SubsequentDocumentCategory,
  _Fatura.SubsequentDocument,
  _Nf.BR_NFeNumber,
  _Nf.BR_NotaFiscal,
  _Nf.BR_NFPartnerRegionCode,
  _Nf.SalesDocumentCurrency,
  _Nf.BR_NFTotalAmount,
  _Nf.BR_NFeDocumentStatus
