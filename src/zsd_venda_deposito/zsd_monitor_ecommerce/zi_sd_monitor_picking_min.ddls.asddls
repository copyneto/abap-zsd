@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Date Time Picking MÍNIMO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_MONITOR_PICKING_MIN
  as select from ZI_SD_MONITOR_PICKING_DOCFLOW
{
  key PrecedingDocument,
      CreationDate,
      min(CreationTime) as CreationTime
}
where
      PrecedingDocumentCategory  = 'J'
  and SubsequentDocumentCategory = 'Q'
group by
  PrecedingDocument,
  CreationDate
