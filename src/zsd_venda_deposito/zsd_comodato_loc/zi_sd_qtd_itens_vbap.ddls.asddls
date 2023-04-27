@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Qtd items sem movito de recusa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_QTD_ITENS_VBAP
  as select from vbap
{
  key vbeln,
      count ( * ) as QtdItem
}
where abgru = ''

group by
  vbeln
