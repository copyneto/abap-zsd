@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Itens com impostos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_RELEX_TAX as select from I_BR_NFTax as _BR_NFTax 
    left outer join  ZI_SD_RELEX_IMPOSTO as _SD_RELEX_IMPOSTO on  _BR_NFTax.BR_TaxType = _SD_RELEX_IMPOSTO.Low  

{
key _BR_NFTax.BR_NotaFiscal,
key _BR_NFTax.BR_NotaFiscalItem,
_SD_RELEX_IMPOSTO.Chave3 as GrupoImposto,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      @Aggregation.default:#SUM
_BR_NFTax.BR_NFItemTaxAmount,
_BR_NFTax. SalesDocumentCurrency
}
