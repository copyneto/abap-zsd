@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Nfe Devolução'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_NFE_DEVOLUCAO
  as select from I_BR_NFItem as _NfItem
  association to I_BR_NFDocument as _NfIHeader on _NfIHeader.BR_NotaFiscal = $projection.NotaFiscal
{
  key _NfItem.BR_NotaFiscal             as NotaFiscal,
  key _NfItem.BR_NotaFiscalItem         as NotaFiscalItem,
      _NfItem.BR_NFSourceDocumentNumber as DocReferencia,
      _NfItem.NetPriceAmount            as UnitCliente,
      _NfIHeader.BR_NFeNumber           as Nfe

}
where
  _NfItem.BR_NFSourceDocumentType = 'BI'
