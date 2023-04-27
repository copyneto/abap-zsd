@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de interface - Histórico de Agendamento'

//@AbapCatalog.viewEnhancementCategory: [#NONE]
//@AccessControl.authorizationCheck: #CHECK
//@EndUserText.label: 'CDS de interface - Histórico de Agendamento'
//@Metadata.ignorePropagatedAnnotations: true
//@ObjectModel.usageType:{
//    serviceQuality: #X,
//    sizeCategory: #S,
//    dataClass: #MIXED
//}
define root view entity ZI_SD_HIST_AGENDAMENTO

  as select from           ztsd_agendamento           as _agend
    inner join             ZI_SD_AGEND_MIN_ITEM       as _teste on  _teste.Ordem = _agend.ordem
                                                                and _teste.Item  = _agend.item
    left outer to one join ZI_SD_FLAG_AGENDAMENTO_MAX as _Flag  on  _Flag.ordem   = _agend.ordem
                                                                and _Flag.item    = _teste.Item
                                                                and _Flag.remessa = _agend.remessa
                                                                and _Flag.nf_e    = _agend.nf_e
    left outer to one join ZI_SD_AGEN_ENTREGA         as _Agen  on  _Agen.SalesOrder     = _agend.ordem
                                                                and _Agen.SalesOrderItem = _teste.Item

  association [1..1] to tvtgt          as _texto on  _texto.vstga = $projection.Motivo
                                                 and _texto.spras = $session.system_language
  association        to ZI_SD_VH_VSTGA as _text  on  _text.Motivo = _agend.motivo
{
  key _agend.ordem              as SalesOrder,
  key _agend.item               as Item,
  key _agend.remessa            as Remessa,
  key case
      when _agend.nf_e is null or _agend.nf_e is initial
      then cast('' as abap.char(13))
      else  _agend.nf_e end     as DocNum,
  key _agend.data_agendada      as DataAgendada,
  key _agend.hora_agendada      as HoraAgendada,

      @ObjectModel.text.element:['TextoMotivo']
      _agend.motivo             as Motivo,
      _text.Texto               as MotivoText,
      _agend.senha              as Senha,
      _agend.usuario            as Usuario,
      _agend.data_registro      as DataRegistro,
      _agend.hora_registro      as HoraRegistro,
      _agend.data_hora_agendada as DataHoraAgendada,
      _agend.observacoes        as Observacoes,
      _Flag.Max_DataHoraAgendada,
      case when _agend.data_hora_agendada = _Flag.Max_DataHoraAgendada
      //           and  _agend.hora_registro      = _Flag.Max_HoraRegistro
      then 'X'
      else ''
      end                       as Agend_Valid,
      _Agen.Plant               as Centro,
      _Agen.DistributionChannel as Canal,
      _texto.bezei              as TextoMotivo

}
//  as select from ztsd_agendamento
//  association        to ZI_SD_FLAG_AGENDAMENTO as _Flag  on  _Flag.ordem = $projection.SalesOrder
//  association        to ZI_SD_AGEN_ENTREGA     as _Agen  on  _Agen.SalesOrder     = $projection.SalesOrder
//                                                         and _Agen.SalesOrderItem = '000010'
//  association [1..1] to tvtgt                  as _texto on  _texto.vstga = $projection.Motivo
//                                                         and _texto.spras = $session.system_language
//{
//  key ordem                     as SalesOrder,
//  key item                      as Item,
//  key remessa                   as Remessa,
//  key nf_e                      as DocNum,
//  key data_agendada             as DataAgendada,
//  key hora_agendada             as HoraAgendada,
//      data_hora_agendada        as DataHoraAgendada,
//      @ObjectModel.text.element:['TextoMotivo']
//      motivo                    as Motivo,
//      senha                     as Senha,
//      observacoes               as Observacoes,
//      data_registro             as DataRegistro,
//      hora_registro             as HoraRegistro,
//      usuario                   as Usuario,
//      _Flag.Max_DataHoraAgendada,
//      case when ztsd_agendamento.data_hora_agendada = _Flag.Max_DataHoraAgendada
//      then 'X'
//      else ''
//      end                       as Agend_Valid,
//      _Agen.Plant               as Centro,
//      _Agen.DistributionChannel as Canal,
//      _texto.bezei              as TextoMotivo
//
//}
