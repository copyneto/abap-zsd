@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interf. - Remessa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_STATUS_TOR
  as select from /scmtms/d_tordrf as _TorDrf
  association to /scmtms/d_torrot as _TorId on _TorId.db_key = $projection.ParentKey


{
  _TorDrf.parent_key         as ParentKey,
  right( _TorDrf.btd_id, 10) as Remessa,
  _TorId.tor_id              as OrdemFrete,
  _TorId.zz_motorista        as Motorista,
  cast( _TorId.created_on    as abap.char(18) ) as DataOF

}
where
      _TorDrf.btd_tco = '73'
  and _TorId.tor_cat  = 'TO'
