@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro de MVKE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_RELEX_FILT_LAST_MVKE
  as select from mvke
{
  key matnr      as Matnr,
  key vkorg      as VKorg,
      max(mvgr3) as Mvgr3
}
group by
  matnr,
  vkorg
