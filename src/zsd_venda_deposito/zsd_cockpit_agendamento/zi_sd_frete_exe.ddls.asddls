@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ordem de Frete exe.'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_FRETE_EXE
  as select from /scmtms/d_torexe                                                                                as _Exe
  //    inner join   ZI_SD_CKPT_AGEN_PARAM( p_modulo : 'SD', p_chave1 : 'ADM_AGENDAMENTO', p_chave2 : 'DEL_EVENT' ) as _Param on _Param.parametro = _Exe.event_code
    inner join   ZI_SD_CKPT_AGEN_PARAM( p_modulo : 'SD', p_chave1 : 'ADM_AGENDAMENTO', p_chave2 : 'EVENT_CODE' ) as _Param on _Param.parametro = _Exe.event_code
{

  key _Exe.db_key,
      _Exe.parent_key,
      //          cast ( _Exe.actual_date as abap.char(20) ) as DataEntrega,
     cast ( max( _Exe.actual_date ) as /scmtms/actual_date  preserving type ) as DataEntrega,
      _Exe.event_code
      //      _Param.parametro
}
where
  _Exe.event_reason is initial
group by
  _Exe.db_key,
  _Exe.parent_key,
  _Exe.event_code
