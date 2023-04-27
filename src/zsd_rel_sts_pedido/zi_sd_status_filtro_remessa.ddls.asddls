@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro de Remessa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_STATUS_FILTRO_REMESSA
  as select from I_SDDocumentProcessFlow
{
  key max(PrecedingDocument) as PrecedingDocument,
      max(PrecedingDocumentCategory) as PrecedingDocumentCategory,
      SubsequentDocument,
      max(SubsequentDocumentCategory) as SubsequentDocumentCategory,
      max(CreationDate)      as CreationDate

}
where
  I_SDDocumentProcessFlow.SubsequentDocumentCategory = 'J'

group by
  SubsequentDocument
