@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Itens de NF Saída Sirius'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_NFitemSirius
  as select from j_1bnflin as NFitem
  association to I_BillingDocumentItemBasic as _BillingDocItem
    on  $projection.ReferenceKey = _BillingDocItem.BillingDocument
    and $projection.Item         = _BillingDocItem.BillingDocumentItem

{

  docnum as Document,
  itmnum as Item,
  refkey as ReferenceKey,

  _BillingDocItem.SalesDocument,
  _BillingDocItem._SalesDocument.CorrespncExternalReference,
  _BillingDocItem._SalesDocument.CustomerPurchaseOrderType,

  /* Associations */
  _BillingDocItem

}
