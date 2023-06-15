@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Campo Agendamento Válido'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_FLAG_AGEND_HORA_VALID
  as select from    ZI_SD_CKPT_AGEND_UNION_APP as _AppAgenda
    left outer join ztsd_agendamento           as _HoraAgendaNfe     on  _HoraAgendaNfe.ordem   = _AppAgenda.SalesOrder
                                                                     and _HoraAgendaNfe.item    = _AppAgenda.SalesOrderItem
                                                                     and _HoraAgendaNfe.remessa = _AppAgenda.Remessa
                                                                     and _HoraAgendaNfe.nf_e    = _AppAgenda.NotaFiscal

    left outer join ztsd_agendamento           as _HoraAgendaRemessa on  _HoraAgendaRemessa.ordem   = _AppAgenda.SalesOrder
                                                                     and _HoraAgendaRemessa.item    = _AppAgenda.SalesOrderItem
                                                                     and _HoraAgendaRemessa.remessa = _AppAgenda.Remessa
                                                                     and _HoraAgendaRemessa.nf_e    = ' '

    left outer join ztsd_agendamento           as _HoraAgendaOrdem   on  _HoraAgendaOrdem.ordem   = _AppAgenda.SalesOrder
                                                                     and _HoraAgendaOrdem.item    = _AppAgenda.SalesOrderItem
                                                                     and _HoraAgendaOrdem.remessa = ' '
                                                                     and _HoraAgendaOrdem.nf_e    = ' ' 
{
  key
      case
      when _HoraAgendaNfe.ordem is not initial
      then _HoraAgendaNfe.ordem
        when _HoraAgendaRemessa.ordem is not initial
      then  _HoraAgendaRemessa.ordem
        else _HoraAgendaOrdem.ordem
        end as ordem,

  key
      case
      when _HoraAgendaNfe.item is not initial
      then _HoraAgendaNfe.item
        when _HoraAgendaRemessa.item is not initial
      then  _HoraAgendaRemessa.item
        else  _HoraAgendaOrdem.item
        end as item,

  key
      case
      when _HoraAgendaNfe.remessa is not initial
      then _HoraAgendaNfe.remessa
        when _HoraAgendaRemessa.remessa is not initial
      then  _HoraAgendaRemessa.remessa
        else _HoraAgendaOrdem.remessa
        end as remessa,

  key
      case
      when _HoraAgendaNfe.nf_e is not initial
      then _HoraAgendaNfe.nf_e
       when _HoraAgendaRemessa.nf_e is not initial
      then  _HoraAgendaRemessa.nf_e
       else cast( coalesce(  _HoraAgendaOrdem.nf_e, '' ) as ze_nota_fiscal  )
       end  as nf_e

}
