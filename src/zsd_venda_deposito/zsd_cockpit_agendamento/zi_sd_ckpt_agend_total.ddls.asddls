@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS calcular total nfe'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_AGEND_TOTAL
  as select from    I_BR_NFItem    as _itm

    left outer join I_BR_NFTax     as _tax   on  _tax.BR_NotaFiscal     = _itm.BR_NotaFiscal
                                             and _tax.BR_NotaFiscalItem = _itm.BR_NotaFiscalItem
    inner join      ztca_param_val as _Param on  _Param.modulo = 'SD'
                                             and _Param.chave1 = 'ADM_AGENDAMENTO'
                                             and _Param.chave2 = 'IMPOSTO_TOTAL_NFE'
                                             and _Param.low    = _tax.TaxGroup


{
  key _itm.BR_NotaFiscal,
  key _itm.BR_NotaFiscalItem,
      _tax.TaxGroup,
            @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      @Aggregation.default:#SUM
      _itm.BR_NFTotalAmountWithTaxes,
      _itm.SalesDocumentCurrency,
            @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      @Aggregation.default:#SUM
      _tax.BR_NFItemTaxAmount

}
