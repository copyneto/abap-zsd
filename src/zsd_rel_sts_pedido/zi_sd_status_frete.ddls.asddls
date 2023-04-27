@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Intef. - Busca Ordem de Frete'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_STATUS_FRETE
  with parameters
    p_cat : /scmtms/tor_category
  as select from /scmtms/d_tordrf as _DRF
    inner join   /scmtms/d_torrot as _ROT on  _ROT.db_key  = _DRF.parent_key
                                          and _ROT.tor_cat = $parameters.p_cat
{
  key _DRF.btd_id      as SalesOrder,
      _ROT.tor_id      as OrdemFrete
}
where
  _DRF.btd_tco = '73'
