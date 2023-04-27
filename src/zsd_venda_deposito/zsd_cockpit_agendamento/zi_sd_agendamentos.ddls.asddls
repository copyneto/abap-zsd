@AbapCatalog.sqlViewName: 'ZVSDAGEN'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta de Agendamentos'
define view ZI_SD_AGENDAMENTOS
  as select distinct from ztsd_agendamento       as _Agen
    inner join            ZI_SD_HIST_AGENDAMENTO as _His_Agen on  _His_Agen.SalesOrder   = _Agen.ordem
                                                              and _His_Agen.DataAgendada = _Agen.data_agendada
                                                              and _His_Agen.HoraAgendada = _Agen.hora_agendada
                                                              and _His_Agen.Agend_Valid  = 'X'
                                                              
 association to ZI_SD_VH_VSTGA as _text on _text.Motivo = _His_Agen.Motivo

{
  key    _Agen.ordem                    as Ordem,
  key    _Agen.item                     as Item,
  key    case
         when _Agen.remessa is not initial
         then _Agen.remessa
         else 'X'
         end                            as Remessa,
  key    _Agen.nf_e                     as NfE,
  key    _Agen.data_agendada            as DataAgendada,
  key    _Agen.hora_agendada            as HoraAgendada,
         max( _Agen.data_hora_agendada) as DataHoraAgendada,
         _Agen.senha                    as Senha,
         _His_Agen.Agend_Valid,
         _Agen.motivo,
         _text.Texto,
         _Agen.observacoes
}

group by
  _Agen.ordem,
  _Agen.item,
  _Agen.remessa,
  _Agen.nf_e,
  _Agen.senha,
  _Agen.data_agendada,
  _Agen.hora_agendada,
  _His_Agen.Agend_Valid,
  _Agen.motivo,
  _text.Texto,
  _Agen.observacoes

