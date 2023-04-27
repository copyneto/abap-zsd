@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS para validar Doc de Entrada'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_RELAT_DOC_ENTRADA
  as select from j_1bnflin as _NfItem

    inner join   j_1bnfdoc as _NfDoc on  _NfDoc.docnum = _NfItem.docnum
                                     and _NfDoc.direct = '1'
                                     and _NfDoc.code   = '100'
{

  key _NfItem.docnum as Docnum,
  key _NfItem.itmnum as Itmnum,
      _NfDoc.docdat  as Docdat,
      _NfDoc.credat  as Credat,
      _NfDoc.waerk   as Waerk,
      _NfDoc.nfenum  as Nfenum,
      _NfDoc.regio   as Regio,
      _NfItem.cfop   as Cfop,
      _NfItem.refkey as Refkey,
      _NfItem.docref as DocRef,
      _NfItem.itmref as ItmRef,
      @Semantics.amount.currencyCode : 'Waerk'
      _NfItem.netwr  as Netwr

}
