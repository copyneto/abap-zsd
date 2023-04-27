@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Fatura de devoluçao App ecommerce'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_FATURA_VEN
  as select from I_SDDocumentProcessFlow as Fatura
  association to ZI_SD_MONITOR_NF  as _Nf
    on _Nf.BR_NFSourceDocumentNumber = $projection.SubsequentDocument
  association to I_BillingDocument as _Billing
    on _Billing.BillingDocument = $projection.SubsequentDocument
{
  Fatura.PrecedingDocument,
  Fatura.SubsequentDocumentCategory,
  Fatura.SubsequentDocument,
  _Nf.BR_NFeNumber,
  _Nf.BR_NotaFiscal,
  _Nf.BR_NFPartnerRegionCode,
  _Nf.SalesDocumentCurrency,
  @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
  _Nf.BR_NFTotalAmount,
  _Nf.BR_NFeDocumentStatus,
  _Billing.BillingDocumentIsCancelled
}
where
      SubsequentDocumentCategory          = 'M'
  and _Billing.BillingDocumentIsCancelled = ''
group by
  PrecedingDocument,
  SubsequentDocumentCategory,
  SubsequentDocument,
  _Nf.BR_NFeNumber,
  _Nf.BR_NotaFiscal,
  _Nf.BR_NFPartnerRegionCode,
  _Nf.SalesDocumentCurrency,
  _Nf.BR_NFTotalAmount,
  _Nf.BR_NFeDocumentStatus,
  _Billing.BillingDocumentIsCancelled
