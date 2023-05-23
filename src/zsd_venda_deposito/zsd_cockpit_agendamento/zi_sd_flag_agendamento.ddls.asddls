@AbapCatalog.sqlViewName: 'ZVSDFLAGAGEND'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flag Agendamento Válido'
define view ZI_SD_FLAG_AGENDAMENTO
  as select from ztsd_agendamento       as _agenda
    inner join   ZI_SD_CKPT_AGEN_DATA   as _data  on  _data.ordem             = _agenda.ordem
                                                  and _data.remessa           = _agenda.remessa
                                                  and _data.nf_e              = _agenda.nf_e
                                                  and _data.Max_data_registro = _agenda.data_registro
    inner join   ZI_SD_FLAG_AGEND_MHORA as _MHORA on  _MHORA.ordem             = _agenda.ordem
                                                  and _MHORA.item              = _agenda.item
                                                  and _MHORA.remessa           = _agenda.remessa
                                                  and _MHORA.nf_e              = _agenda.nf_e
                                                  and _MHORA.data_registro     = _data.Max_data_registro
                                                  and _MHORA.Max_hora_registro = _agenda.hora_registro

{
  key _agenda.ordem,
  key _agenda.item,
  key _agenda.remessa,
  key _agenda.nf_e,
      max( _agenda.data_hora_agendada ) as Max_DataHoraAgendada
      //      max( _agenda.hora_registro )      as Max_HoraRegistro
}
group by
  _agenda.ordem,
  _agenda.item,
  _agenda.remessa,
  _agenda.nf_e
//_agenda.data_hora_agendada
