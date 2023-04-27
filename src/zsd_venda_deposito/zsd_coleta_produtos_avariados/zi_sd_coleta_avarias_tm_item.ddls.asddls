@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'TM Item Coleta Avarias'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity zi_sd_coleta_avarias_tm_item
  as select from /scmtms/d_torite
{
  key parent_key,
      max( base_btd_id ) as remessaBtdId
}

where
      ref_bo       = 'TOR'
  and base_btd_tco = '73'
group by
  parent_key
