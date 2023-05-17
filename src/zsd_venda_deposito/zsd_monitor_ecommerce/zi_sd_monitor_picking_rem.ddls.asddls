@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Date Time Picking Remessa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_MONITOR_PICKING_REM
  as select from    I_SDDocumentProcessFlow   as _SDDocumentFlow
    left outer join ZI_SD_MONITOR_PICKING     as _Picking on  _Picking.PrecedingDocument          = _SDDocumentFlow.SubsequentDocument
                                                          and _Picking.PrecedingDocumentCategory  = 'J'
                                                          and _Picking.SubsequentDocumentCategory = 'Q'
    inner join      ZI_SD_MONITOR_PICKING_MIN as _Min     on  _Picking.PrecedingDocument = _Min.PrecedingDocument
                                                          and _Picking.CreationDate      = _Min.CreationDate
                                                          and _Picking.CreationTime      = _Min.CreationTime

{
  key _SDDocumentFlow.PrecedingDocument,
      min( _SDDocumentFlow.SubsequentDocumentItem ) as SubsequentDocumentItem,
      _Picking.PrecedingDocumentCategory,
      _Picking.SubsequentDocumentCategory,
      max( _Picking.CreationDate )                  as CreationDate,
      max( _Picking.CreationTime )                  as CreationTime
}
where
  _SDDocumentFlow.SubsequentDocumentCategory = 'J'
//  and _SDDocumentFlow.SubsequentDocumentItem     = '000010'

group by
  _SDDocumentFlow.PrecedingDocument,
  _Picking.PrecedingDocumentCategory,
  _Picking.SubsequentDocumentCategory
