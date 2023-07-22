@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Agendamento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}

define view entity ZI_SD_CKPT_FAT_AGENDAMENTO
  as select from knvv as _KNVV
  association to tvv5t as _TVV5T on  _TVV5T.kvgr5 = $projection.GrupoClienteAgenda
                                 and _TVV5T.spras = $session.system_language
{
  key _KNVV.kunnr,
      _KNVV.kvgr5 as GrupoClienteAgenda,
      _KNVV.vkorg,
      _KNVV.vtweg,
      _KNVV.spart,
      _TVV5T.bezei as GrupoClienteAgendaTexto

//      case
//          when _KNVV.kvgr5 is initial then _TVV5T.bezei
//          else concat( _TVV5T.bezei, concat( ' (', concat( _KNVV.kvgr5, ')' ) ) )
//      end as GrupoClienteAgenda
}
group by
  _KNVV.kunnr,
  _KNVV.vkorg,
  _KNVV.vtweg,
  _KNVV.spart,
  _KNVV.kvgr5,
  _TVV5T.bezei

//define view entity ZI_SD_CKPT_FAT_AGENDAMENTO
//  as select from I_SalesOrderPartner as _Partner
//  association to ZI_SD_CKPT_FAT_AGENDAMENTO_AUX as _agendAux on _agendAux.kunnr = $projection.Customer
//{
//  key _Partner.SalesOrder,
//  key _Partner.Customer,
//      concat( concat(_agendAux.kvgr5, '-'), _agendAux.bezei ) as Agendamento
//}
//where
//  _Partner.Customer is not initial
//group by
//  _Partner.SalesOrder,
//  _Partner.Customer,
//  _agendAux.kvgr5,
//  _agendAux.bezei
