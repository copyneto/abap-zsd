@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro Status Faturamento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_FILT_STATUS_FAT
  as select from I_SDDocumentProcessFlow
{
  key PrecedingDocument,
      max(SubsequentDocument) as SubsequentDocument
}
where
      SubsequentDocumentCategory = 'M'
  and SubsequentDocumentItem     = '000010'
group by
  PrecedingDocument
