@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'FIltro de Agendamentos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_FILTER_AGEND
  as select from ztsd_agendamento
{
  key ordem              as Ordem,
  key remessa            as Remessa,
  key nf_e               as nf_e,
  key data_agendada      as data_agendada,
  key hora_agendada      as hora_agendada,
      motivo             as Motivo,
      senha              as Senha,
      usuario            as Usuario,
      data_registro      as data_registro,
      hora_registro      as hora_registro,
      data_hora_agendada as data_hora_agendada,
      observacoes        as Observacoes
}
group by
  ordem,
  remessa,
  nf_e,
  data_agendada,
  hora_agendada,
  motivo,
  senha,
  usuario,
  data_registro,
  hora_registro,
  data_hora_agendada,
  observacoes
