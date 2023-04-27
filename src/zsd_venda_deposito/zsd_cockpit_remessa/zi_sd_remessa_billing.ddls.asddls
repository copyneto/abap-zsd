@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS valida fatura'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REMESSA_BILLING
  as select from I_BillingDocumentItem as _item
    inner join   I_BillingDocument     as _head on  _item.BillingDocument            =  _head.BillingDocument
                                                and _head.BillingDocumentIsCancelled <> 'X'
                                                and _head.SDDocumentCategory         =  'M'

{
  key _item.BillingDocument,
  key _item.BillingDocumentItem,
      _item.ReferenceSDDocument,
      _item.SalesDocument,
      _item.SalesDocumentItem

}
