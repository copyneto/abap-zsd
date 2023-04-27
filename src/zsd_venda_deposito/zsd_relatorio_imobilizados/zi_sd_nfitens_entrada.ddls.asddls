@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Itens de entrada'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_NFITENS_ENTRADA
  as select from I_BR_NFItem as _NfItem


    inner join   j_1bnfdoc   as _NfDocEntrada on _NfDocEntrada.docnum = _NfItem.BR_NotaFiscal


    inner join   I_BR_NFTax  as _NfTaxEntrada on  _NfTaxEntrada.BR_NotaFiscal     = _NfItem.BR_NotaFiscal
                                              and _NfTaxEntrada.BR_NotaFiscalItem = _NfItem.BR_NotaFiscalItem
                                              and _NfTaxEntrada.BR_TaxType        = 'ICM3'
{


  key _NfDocEntrada.docnum      as Docnum,
  key _NfItem.BR_NotaFiscalItem as Item,

      _NfItem.BR_CFOPCode,

      _NfItem.BR_NFSourceDocumentNumber,

      _NfItem._BR_NotaFiscal.BR_NFIssueDate,

      _NfItem.BR_NotaFiscal,


      _NfItem._BR_NotaFiscal.BR_NFeNumber,

      _NfItem.BaseUnit          as Unidade,

      @Semantics.amount.currencyCode:'Unidade'
      _NfItem.NetValueAmount,

      @Semantics.amount.currencyCode:'Unidade'
      _NfTaxEntrada.BR_NFItemBaseAmount,
      @Semantics.amount.currencyCode:'Unidade'
      _NfTaxEntrada.BR_NFItemTaxRate,

      @Semantics.amount.currencyCode:'Unidade'
      _NfTaxEntrada.BR_NFItemTaxAmount,

      @Semantics.amount.currencyCode:'Unidade'
      _NfTaxEntrada.BR_NFItemOtherBaseAmount


}
