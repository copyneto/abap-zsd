@AbapCatalog.sqlViewName: 'ZVSD_FRETE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Tratativa de frete'
define view ZI_SD_COCKPIT_FRE 
as select from /scmtms/d_torrot as _TorId
  association to /scmtms/d_tordrf as _TorDrf on _TorDrf.parent_key = _TorId.db_key {

 case
    when _TorDrf.btd_tco = '73' then right( _TorDrf.btd_id, 10)
    else right( _TorId.base_btd_id, 10 )
    end              as Remessa,
    tor_id as OrdemFrete
    
} where _TorDrf.btd_tco = '73'
    and _TorId.tor_cat  = 'TO'
