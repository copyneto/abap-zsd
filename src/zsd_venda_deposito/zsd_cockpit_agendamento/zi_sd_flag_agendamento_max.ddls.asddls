@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Flag agendamento váildo'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_FLAG_AGENDAMENTO_MAX 
 as select from ZI_SD_FLAG_AGENDAMENTO as _flag
   inner join ztsd_agendamento as _agend on _flag.ordem = _agend.ordem
                                        and _flag.item  = _agend.item
                                        and _flag.remessa = _agend.remessa
                                        and _flag.nf_e    = _agend.nf_e
//                                        and _agend.data_agendada = left( cast(_flag.Max_DataHoraAgendada as abap.char(20)),8)
                                        and _agend.data_hora_agendada = _flag.Max_DataHoraAgendada
 {
  key _agend.ordem,
  key _agend.item,
  key _agend.remessa,
  key _agend.nf_e,
  _flag.Max_DataHoraAgendada
 }
