@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Mostrar primeiro item da fatura'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_FATURA_PRIMEIRO_ITEM
  as select from I_BillingDocumentItem as FaturaItem
{
  key BillingDocument,

      min(BillingDocumentItem) as BillingDocumentItem,
      min(SalesDocument)       as SalesDocument,
      min(SalesDocumentItem)   as SalesDocumentItem

}
group by
  FaturaItem.BillingDocument
