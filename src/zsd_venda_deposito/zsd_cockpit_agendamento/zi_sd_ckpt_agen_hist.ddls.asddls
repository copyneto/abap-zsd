@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS historico máx'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_AGEN_HIST
  as select from           ztsd_agendamento     as _Agen
    left outer to one join ZI_SD_CKPT_AGEN_FLAG as _His_Agen on  _His_Agen.ordem   = _Agen.ordem
                                                             and _His_Agen.remessa = _Agen.remessa
     association to ZI_SD_VH_VSTGA as _text on _text.Motivo = _Agen.motivo
{
  key    _Agen.ordem                    as Ordem,

  key    case
         when _Agen.remessa is not initial
         then _Agen.remessa
         else 'X'
         end                            as Remessa,
  key    _Agen.nf_e                     as NfE,
  key    _Agen.data_agendada            as DataAgendada,
  key    _Agen.hora_agendada            as HoraAgendada,
         _Agen.data_hora_agendada       as DataHoraAgendada,
         _His_Agen.Max_DataHoraAgendada as tttt,
         _His_Agen.Max_HoraRegistro     as dddd,
         _Agen.hora_registro            as yyyy,
         _Agen.senha                    as Senha,
         case
         when _Agen.data_hora_agendada = _His_Agen.Max_DataHoraAgendada


         then 'X' else 'Y' end          as Agend_Valid,
         _Agen.motivo,
         _text.Texto,
         _Agen.observacoes
}
