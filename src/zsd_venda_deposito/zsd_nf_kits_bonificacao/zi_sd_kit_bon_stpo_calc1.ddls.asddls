@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Parâmetros STPO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_KIT_BON_STPO_CALC1
  as select from stpo as _ListaTecItem
  association to stko as _ListaTec on _ListaTec.stlnr = _ListaTecItem.stlnr
{
  key _ListaTecItem.stlty                                                   as Stlty,
  key _ListaTecItem.stlnr                                                   as Stlnr,
  key _ListaTecItem.stlkn                                                   as Stlkn,
  key _ListaTecItem.stpoz                                                   as Stpoz,
      _ListaTecItem.idnrk                                                   as Idnrk,
      fltp_to_dec( cast( _ListaTecItem.menge as abap.fltp( 13, 3 ) ) /
      cast( _ListaTec.bmeng  as abap.fltp( 13, 3 ) ) as abap.dec( 13, 3 ) ) as Menge,
      _ListaTecItem.meins                                                   as Meins
}
