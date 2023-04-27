@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Lista técnica dos materiais'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_KIT_BON_MAST
  as select from    mast                           as _mast
    inner join      ZI_SD_KIT_BON_STPO             as _stpo          on _stpo.Stlnr = _mast.stlnr

   
  //  association [1] to stpo                as _stpo  on  _stpo.stlnr = _mast.stlnr
  //                                                   and _stpo.erskz = 'X'
  //  association [1] to ZI_SD_KIT_BON_STLAN as _STLAN on $projection.Stlan = _STLAN.STLAN
  association [1] to ZI_SD_KIT_BON_ERSKZ as _ERSKZ on _ERSKZ.ERSKZ = $projection.Erskz
{

  key _mast.matnr as Matnr,
  key _mast.werks as Werks,
      _mast.stlan,
      //_STLAN.STLAN as Stlan,
      _mast.stlnr as Stlnr,
      _mast.stlal as Stlal,
      _stpo.Erskz as Erskz,
      _stpo.Idnrk as Idnrk,
      _stpo.Posnr as Posnr

}
where
  _mast.stlan = '1'

group by
  _mast.matnr,
  _mast.werks,
  _mast.stlan,
  _mast.stlnr,
  _mast.stlal,
  _stpo.Erskz,
  _stpo.Idnrk,
  _stpo.Posnr
