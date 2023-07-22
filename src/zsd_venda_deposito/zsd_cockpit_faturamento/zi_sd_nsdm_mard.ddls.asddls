@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Dados estoque mard'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #XL,
  dataClass: #MIXED
}
define view entity zi_sd_nsdm_mard
  as select from zi_sd_mard as _mard
  association [0..1] to nsdm_e_mard_diff as _mardDiff on  _mardDiff.matnr = _mard.matnr
                                                      and _mardDiff.werks = _mard.werks
                                                      and _mardDiff.lgort = _mard.lgort
{
  key _mard.matnr,
  key _mard.werks,
  key _mard.lgort,
      cast( 'UN' as meins ) as Unidade,
      @Semantics.quantity.unitOfMeasure : 'Unidade'
      _mardDiff.labst
}
