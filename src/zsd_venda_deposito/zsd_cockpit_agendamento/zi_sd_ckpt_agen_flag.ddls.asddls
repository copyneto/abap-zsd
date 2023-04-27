@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS flag máx registro'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_AGEN_FLAG
  as select from ztsd_agendamento     as _agenda
    inner join   ZI_SD_CKPT_AGEN_DATA as _data  on  _data.ordem             = _agenda.ordem
                                                and _data.remessa           = _agenda.remessa
                                                and _data.Max_data_registro = _agenda.data_registro
    inner join   ZI_SD_CKPT_AGEN_HORA as _MHORA on  _MHORA.ordem             = _agenda.ordem
                                                and _MHORA.remessa           = _agenda.remessa
                                                and _MHORA.data_registro     = _agenda.data_registro
                                                and _MHORA.Max_hora_registro = _agenda.hora_registro

{
  key _agenda.ordem,
  key _agenda.remessa,
      max( _agenda.data_registro )      as Max_DataRegistro,
      max( _agenda.data_hora_agendada ) as Max_DataHoraAgendada,
      max( _agenda.hora_registro )      as Max_HoraRegistro
}
group by
  _agenda.ordem,
  _agenda.remessa
