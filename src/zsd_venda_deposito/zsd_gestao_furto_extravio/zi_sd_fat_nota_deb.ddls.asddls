@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Fatura nota débito'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_FAT_NOTA_DEB
  as select from I_BillingDocumentItem as _FatItem //I_SDDocumentProcessFlow
    inner join   I_BillingDocument     as _Fat   on  _Fat.BillingDocument            =  _FatItem.BillingDocument
                                                 and _Fat.BillingDocumentIsCancelled <> 'X'
    inner join   ZI_SD_OV_NOTA_DEB     as _Param on _Param.OrderTypeDeb = _Fat.BillingDocumentType
  association to ZI_SD_MONITOR_NF as _Nfe on _Nfe.BR_NFSourceDocumentNumber = $projection.SubsequentDocument
{

  key _FatItem.BillingDocument          as SubsequentDocument,
  key min(_FatItem.BillingDocumentItem) as BillingDocumentItem,
      _FatItem.SalesDocument,
      min( _FatItem.SalesDocumentItem ) as SalesDocumentItem,
      _Nfe.BR_NFeNumber                 as BR_NFeNumber,
      _FatItem.Plant
}
group by
  _FatItem.BillingDocument,
  _FatItem.SalesDocument,
  _Nfe.BR_NFeNumber,
  _FatItem.Plant
