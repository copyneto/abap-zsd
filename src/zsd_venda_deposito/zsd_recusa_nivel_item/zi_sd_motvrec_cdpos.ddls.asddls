@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro CDPOS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_MOTVREC_CDPOS
  as select from cdpos
{
  key tabkey,
  key objectclas,
  key tabname,
  key fname,
  key objectid,
      max(changenr) as changenr

}
where
      objectclas = 'VERKBELEG'
  and tabname    = 'VBAP'
  and fname      = 'ABGRU'
group by
  tabkey,
  objectclas,
  tabname,
  fname,
  objectid
