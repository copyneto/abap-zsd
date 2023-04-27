@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help - Serie'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_VH_SERIE
  as select from objk as _Serie
{
             @ObjectModel.virtualElement: true
             @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CONVERSION_GERNR'
  key        sernr as Serie,
             @EndUserText.label: 'Descrição'
  key        matnr as Material
//             sernr as SerieInter


}
group by
  _Serie.sernr,
  _Serie.matnr
