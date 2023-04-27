@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Minimo Item da Remessa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_AGEND_MIN_REM 
  as select from ZI_SD_CKPT_AGEN_REMESSA as _Remessa
{

  key _Remessa.SalesOrder,
  key _Remessa.Document,
     min( _Remessa.Item ) as Item


}   where _Remessa.Document is not initial
group by
  _Remessa.SalesOrder,
  _Remessa.Document
