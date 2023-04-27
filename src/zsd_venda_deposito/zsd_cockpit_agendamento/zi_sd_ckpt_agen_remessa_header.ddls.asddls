@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca Remessa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_AGEN_REMESSA_HEADER
  as select from ZI_SD_CKPT_AGEN_REMESSA as _Remessa
{

  key _Remessa.SalesOrder,
  key _Remessa.Document,
      _Remessa.NotaFiscal


}   where _Remessa.Document is not initial
group by
  _Remessa.SalesOrder,
  _Remessa.Document,
  _Remessa.NotaFiscal

