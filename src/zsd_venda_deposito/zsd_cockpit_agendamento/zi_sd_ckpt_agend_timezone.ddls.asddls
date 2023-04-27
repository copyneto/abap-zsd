@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS time zone'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_AGEND_TIMEZONE 
  with parameters
    p_cat : /scmtms/tor_category
  as select from /scmtms/d_tordrf as _DRF
    inner join   /scmtms/d_tordrf as _DRF1 on  _DRF1.db_key  = _DRF.db_key
                                           and _DRF1.btd_tco = '73'
    inner join   /scmtms/d_torrot as _ROT  on  _ROT.db_key  = _DRF.parent_key
                                           and _ROT.tor_cat = $parameters.p_cat
    inner join   kna1             as _KNA  on _KNA.kunnr = _ROT.consigneeid
    inner join   adrc             as _ADR  on _ADR.addrnumber = _KNA.adrnr

{
  key right( _DRF.btd_id, 10) as SalesOrder,
      _ROT.tor_id             as OrdemFrete,
      _ADR.time_zone
}
group by
  _DRF.btd_id,
  _ROT.tor_id,
  _ADR.time_zone
