@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cockpit Devolução Numero NFE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COCKPIT_DEVOLUCAO_NFNUM
  as select from I_BR_NFItem as _NFItem
  association to I_BR_NFDocument as _NFDoc on _NFDoc.BR_NotaFiscal = _NFItem.BR_NotaFiscal
{

  key  _NFItem.BR_NotaFiscal             as NotaFiscal,
       min( _NFItem.BR_NotaFiscalItem )  as NotaFiscalItem,
       _NFItem.BR_NFSourceDocumentNumber as DocOrigem,
       _NFDoc.BR_NFeNumber               as NfeComp,
       @Semantics.amount.currencyCode: 'MoedaSD'
       @Aggregation.default:#SUM
       _NFDoc.BR_NFTotalAmount           as NfTotal,
       _NFDoc.SalesDocumentCurrency      as MoedaSD,
       _NFDoc.BR_NFeDocumentStatus       as DocNfStatus,
       _NFDoc.BR_NotaFiscal              as DocNf,
       _NFDoc.BR_NFIsCanceled            as Cancelado
}
where
  _NFItem.BR_NFSourceDocumentType = 'BI'
group by
  _NFItem.BR_NotaFiscal,
  _NFItem.BR_NFSourceDocumentNumber,
  _NFDoc.BR_NFeNumber,
  _NFDoc.BR_NFTotalAmount,
  _NFDoc.SalesDocumentCurrency,
  _NFDoc.BR_NFeDocumentStatus,
  _NFDoc.BR_NotaFiscal,
  _NFDoc.BR_NFIsCanceled
