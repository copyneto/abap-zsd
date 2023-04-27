@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Parâmetros STPO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_KIT_BON_STPO
  as select from stpo                as _STPO
    inner join   ZI_SD_KIT_BON_ERSKZ as _ERSKZ on  _ERSKZ.ERSKZ = _STPO.erskz
{
  key _STPO.stlnr as Stlnr,
  key _STPO.stlkn as Stlkn,
  key _STPO.stpoz as Stpoz,
      _STPO.idnrk as Idnrk,
      _STPO.erskz as Erskz,
      _STPO.posnr as Posnr
}
