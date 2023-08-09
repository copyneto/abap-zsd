@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'nsdm_e_mard_diff labst'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #L,
  dataClass: #MIXED
}
define view entity zi_sd_nsdm_mard_diff
  as select from matdoc_extract
{
  key matbf                 as matnr,
  key werks,
  key lgort_sid             as lgort,
      cast( 'UN' as meins ) as Unidade,
      @Semantics.quantity.unitOfMeasure : 'Unidade'
//      stock_qty_l2     as labst
      sum(stock_qty_l2)     as labst

}
where
      stock_ind_l2 = ''
  and sobkz        = ''
  and lbbsa_sid    = '01'
group by
  matbf,
  werks,
  lgort_sid
