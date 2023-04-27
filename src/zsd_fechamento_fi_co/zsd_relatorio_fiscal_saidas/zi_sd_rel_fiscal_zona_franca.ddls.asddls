@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS tax zona franca'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REL_FISCAL_ZONA_FRANCA 
as select from I_BR_NFTax as _Tax 
{
  key _Tax.BR_NotaFiscal,
  key _Tax.BR_NotaFiscalItem,
  key _Tax.BR_TaxType,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      @Aggregation.default:#SUM
      _Tax.BR_NFItemTaxAmount,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      @Aggregation.default:#SUM
      _Tax.BR_NFItemBaseAmount,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      @Aggregation.default:#SUM
      _Tax.BR_NFItemExcludedBaseAmount,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      @Aggregation.default:#SUM
      _Tax.BR_NFItemOtherBaseAmount,
      _Tax.SalesDocumentCurrency,
      _Tax.BR_NFItemTaxRate

}
where
_Tax.BR_TaxType = 'ICZF' or
_Tax.BR_TaxType = 'ICZ6' or
_Tax.BR_TaxType = 'ICZT' or
_Tax.BR_TaxType = 'ICFD' 
