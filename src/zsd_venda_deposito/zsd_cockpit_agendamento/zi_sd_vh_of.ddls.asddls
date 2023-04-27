@AbapCatalog.sqlViewName: 'ZVSDOF'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help Ordem Frete'
define view ZI_SD_VH_OF
  as select from /scmtms/d_tordrf as _TorDrf
  association to /scmtms/d_torrot as _TorId on _TorId.db_key = $projection.ParentKey


{
      @UI.hidden: true
  key _TorDrf. db_key            as DB_Key,
      @UI.hidden: true
      @EndUserText.label: 'Parent  NodeID'
      _TorDrf.parent_key         as ParentKey,
      @EndUserText.label: 'Ordem Frete'
      _TorId.tor_id              as OrdemFrete

}
where
      _TorDrf.btd_tco = '73'
  and _TorId.tor_cat  = 'TO'
