@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Campo Agendamento Válido'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_FLAG_AGEND_VALID
  as select from ztsd_agendamento
{
  key ordem,
      data_agendada,
      max( data_agendada ) as Max_DataAgendada,
      hora_agendada,
      max( hora_agendada ) as Max_HoraAgendada
}
group by
 ordem, data_agendada, hora_agendada
