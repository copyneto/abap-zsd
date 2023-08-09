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
  as select from           ZI_SD_CKPT_FILTER_AGEND as _agend

    left outer to one join ZI_SD_AGEND_MIN_ITEM    as _MinItem on  _MinItem.Ordem   = _agend.Ordem
    //                                                            and _MinItem.Item    = _agend.item
                                                               and _MinItem.Remessa = _agend.Remessa
                                                               and _MinItem.Nfe     = _agend.nf_e

  //      left outer to one join ZI_SD_FLAG_AGENDAMENTO_MAX as _Flag  on  _Flag.ordem   = _agend.ordem
  //                                                                  and _Flag.item    = _teste.Item
  //                                                                  and _Flag.remessa = _agend.remessa
  //                                                                  and _Flag.nf_e    = _agend.nf_e

    left outer to one join ZI_SD_CKPT_LAST_DAT     as _Flag    on  _Flag.ordem   = _agend.Ordem
                                                               and _Flag.remessa = _agend.Remessa
//                                                               and _Flag.nf_e    = _agend.nf_e

    left outer to one join ZI_SD_AGEN_ENTREGA      as _Agen    on  _Agen.SalesOrder     = _agend.Ordem
                                                               and _Agen.SalesOrderItem = _MinItem.Item
                                                               and _Agen.Remessa        = _agend.Remessa

  //    left outer join ZI_SD_CKPT_AGEN_HIST as _Hist on _Hist.Ordem = _agend.ordem
  //                                                 and _HIst.Remessa

  association [1..1] to tvtgt          as _texto on  _texto.vstga = $projection.Motivo
                                                 and _texto.spras = $session.system_language

  association        to ZI_SD_VH_VSTGA as _text  on  _text.Motivo = _agend.Motivo

  association        to ZI_CA_VH_USER  as _User  on  _User.Bname = $projection.Usuario
{
  key _agend.Ordem              as SalesOrder,
  key _MinItem.Item             as Item,
  key _agend.Remessa            as Remessa,
  key case
      when _agend.nf_e is null or _agend.nf_e is initial
      then cast('' as abap.char(13))
      else  _agend.nf_e end     as DocNum,
  key _agend.data_agendada      as DataAgendada,
  key _agend.hora_agendada      as HoraAgendada,

      @ObjectModel.text.element:['TextoMotivo']
      _agend.Motivo             as Motivo,
      _text.Texto               as MotivoText,
      _agend.Senha              as Senha,
      _agend.Usuario            as Usuario,
      _agend.data_registro      as DataRegistro,
      _agend.hora_registro      as HoraRegistro,
      _agend.data_hora_agendada as DataHoraAgendada,
      _agend.Observacoes        as Observacoes,

      //      _Flag.Max_DataHoraAgendada,
      //      case when _agend.data_hora_agendada = _Flag.Max_DataHoraAgendada
      //      //           and  _agend.hora_registro      = _Flag.Max_HoraRegistro
      _agend.data_hora_agendada as Max_DataHoraAgendada,

      case when _agend.data_registro = _Flag.Max_data_registro
            and _agend.hora_registro = _Flag.Max_hora_registro
             then 'X'
           else '' end          as Agend_Valid,

      case when _agend.data_registro = _Flag.Max_data_registro
            and _agend.hora_registro = _Flag.Max_hora_registro
             then 3
           else 0 end           as FlagCriticality,

      _Agen.Plant               as Centro,
      _Agen.DistributionChannel as Canal,
      _texto.bezei              as TextoMotivo,
      _User.Text                as UserName

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
