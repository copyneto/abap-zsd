@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Nota Fiscal'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_MONITOR_NF
  as select from I_BR_NFItem
  association to I_BR_NFDocument as _Nfe on _Nfe.BR_NotaFiscal = $projection.BR_NotaFiscal
{
  BR_NFSourceDocumentNumber,
  BR_NotaFiscal,
  SalesDocumentCurrency,
  _Nfe.BR_NFeNumber,
  _Nfe.BR_NFPartnerRegionCode,
  _Nfe.BR_NFIsPrinted,
  @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
  _Nfe.BR_NFTotalAmount,
  _Nfe.BR_NFeDocumentStatus

}
where
  BR_NFSourceDocumentType = 'BI'
group by
  BR_NFSourceDocumentNumber,
  BR_NotaFiscal,
  SalesDocumentCurrency,
  _Nfe.BR_NFeNumber,
  _Nfe.BR_NFPartnerRegionCode,
  _Nfe.BR_NFIsPrinted,
  _Nfe.BR_NFTotalAmount,
  _Nfe.BR_NFeDocumentStatus
