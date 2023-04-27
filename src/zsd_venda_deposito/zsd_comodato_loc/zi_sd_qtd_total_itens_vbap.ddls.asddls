@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Qtd Total items sem movito de recusa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_QTD_TOTAL_ITENS_VBAP
  as select from vbap
{
  key vbeln,
      count ( * ) as QtdItem
}
group by
  vbeln
