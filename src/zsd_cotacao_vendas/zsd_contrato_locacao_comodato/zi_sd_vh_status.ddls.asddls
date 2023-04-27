@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help - Status'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_VH_STATUS
  as select from ZI_SD_CONTR_LOC_COMODATO_APP
{
      @EndUserText: { label: 'Status'}
  key Status
}
group by
  Status
