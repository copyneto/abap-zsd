@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help - PurchaseOrderByCustomer'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable:true
define view entity ZI_SD_VH_PurchaseOrderCustomer
  as select from I_SalesContract
{
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @EndUserText.label: 'Solicitação'
  key PurchaseOrderByCustomer
}
where
  PurchaseOrderByCustomer is not initial
group by
  PurchaseOrderByCustomer
