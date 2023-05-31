@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Impostos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
//@VDM: {
//        viewType: #COMPOSITE
//        }
define view entity ZI_SD_REL_FISCAL_SAIDA_TAX
  with parameters
//    modulo : ze_param_modulo,
//    chave1 : ze_param_chave,
//    chave2 : ze_param_chave,
    chave3 : ze_param_chave_3
  as select from ztca_param_par as _Param
  association to I_BR_NFTax as _Tax on _Tax.BR_TaxType = _Param.chave3
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
      _Tax.BR_NFItemTaxRate,
      _Tax.BR_NFItemIsStatisticalTax

}
where
      _Param.modulo = 'SD'
  and _Param.chave1 = 'RELAT_FISCAL'
  and _Param.chave2 = 'TIPOS DE IMPOSTO'
  and _Param.chave3 = $parameters.chave3
