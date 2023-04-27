@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Date Time Picking'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_MONITOR_PICKING
  as select from ZI_SD_MONITOR_PICKING_DOCFLOW as _Main
  //    inner join   ZI_SD_MONITOR_PICKING_MIN as _Min on _Main.PrecedingDocument = _Min.PrecedingDocument
  //                                                  and _Main.CreationDate      = _Min.CreationDate
  //                                                  and _Main.CreationTime      = _Min.CreationTime
{
  key _Main.PrecedingDocument,
      _Main.PrecedingDocumentCategory,
      _Main.SubsequentDocumentCategory,
      _Main.CreationDate,
      _Main.CreationTime
}
group by
  _Main.PrecedingDocument,
  _Main.PrecedingDocumentCategory,
  _Main.SubsequentDocumentCategory,
  _Main.CreationDate,
  _Main.CreationTime
