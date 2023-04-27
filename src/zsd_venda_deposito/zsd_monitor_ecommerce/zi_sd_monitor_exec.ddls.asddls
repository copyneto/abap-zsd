@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Tor Execution'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_MONITOR_EXEC
  as select from /scmtms/d_torexe  as _Exec
    inner join   ZI_SD_MONITOR_EVE as _Param
      on _Param.EventCode = _Exec.event_code
  //  association to /scmtms/d_torrot as _TorId on _TorId.db_key = $projection.ParentKey


{
       //  key _Exec.db_key      as DbKey,
  key  _Exec.parent_key  as ParentKey,
       _Exec.actual_date as ActualDate,
       _Exec.event_code  as EventCode,
       _Exec.ext_loc_id  as ExtLocId,
       _Param.EventCode  as EventCodeParam
       //      _TorId.tor_id     as OrdemFrete
}
//where
//  _TorId.tor_cat = 'TO'
