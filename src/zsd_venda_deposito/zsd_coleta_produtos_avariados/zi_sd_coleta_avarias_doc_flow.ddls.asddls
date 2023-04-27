@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Fuxo documento colega avarias'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity zi_sd_coleta_avarias_doc_flow
  as select from I_SDDocumentMultiLevelProcFlow as _SDDocumentFlow
{
  PrecedingDocument                                          as ordemVendas,
  max( SubsequentDocument )                                  as remessa,
  concat( '0000000000000000000000000', SubsequentDocument  ) as remessaBtdId
}
where
  SubsequentDocumentCategory = 'J'
group by
  PrecedingDocument,
  SubsequentDocument
