@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Event Ordem Frete'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REMESSA_FRETE_EVENT2 
  as select from ZI_SD_REMESSA_FRETE_EVENT as _Fret
  
  inner join /scmtms/d_torrot as _ROT  on _Fret.OrdemFrete = _ROT.tor_id
  and  _ROT.tor_cat = 'TO'

    inner join   /scmtms/d_tordrf as _DRF on  _ROT.db_key  = _DRF.parent_key
                                          and _DRF.btd_tco = '73'
    inner join   /scmtms/d_torexe as _EXE on _EXE.parent_key = _DRF.parent_key 
                                          and _EXE.actual_date = _Fret.Data
                                          and _EXE.execution_id = _Fret.Id
    inner join   /scmtms/c_ev_tyt as _Tyt on _Tyt.tor_event  = _EXE.event_code 
                                          and _Tyt.langu = $session.system_language
{
  key  _Fret.OrdemFrete,
       _EXE.event_code ,
       _Tyt.description_s as EventCode
     
}
group by
_Fret.OrdemFrete,
_EXE.event_code,
_Tyt.description_s
 