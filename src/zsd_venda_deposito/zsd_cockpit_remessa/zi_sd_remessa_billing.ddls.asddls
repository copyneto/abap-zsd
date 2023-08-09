@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS valida fatura'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #L,
    dataClass: #MIXED
}
define view entity ZI_SD_REMESSA_BILLING
  as select from vbrk as _Header
    inner join   vbrp as _Item on _Item.vbeln = _Header.vbeln
{
  key _Header.vbeln as BillingDocument,
  key _Item.posnr   as BillingDocumentItem,
      _Item.vgbel   as ReferenceSDDocument,
      _Item.vgpos   as ReferenceSDDocumentItem,
      _Item.aubel   as SalesDocument,
      _Item.aupos   as SalesDocumentItem,
      
      _Header.buchk as AccountingPostingStatus,
      _Header.fkdat as BillingDocumentDate,
      _Header.fktyp as BillingDocumentCategory,
      _Header.fkart as BillingDocumentType
      
      
}
where
      _Header.vbtyp =  'M'
  and _Header.fksto <> 'X'

//  as select from I_BillingDocumentItem as _item
//    inner join   I_BillingDocument     as _head on  _item.BillingDocument            =  _head.BillingDocument
//                                                and _head.BillingDocumentIsCancelled <> 'X'
//                                                and _head.SDDocumentCategory         =  'M'
//
//{
//  key _item.BillingDocument,
//  key _item.BillingDocumentItem,
//      _item.ReferenceSDDocument,
//      _item.ReferenceSDDocumentItem,
//      _item.SalesDocument,
//      _item.SalesDocumentItem
//
//}
