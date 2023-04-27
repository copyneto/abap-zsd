@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Agendamento  Auxiliar'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZI_SD_CKPT_FAT_AGENDAMENTO_AUX
  as select from knvv as _KNVV
  association to tvv5t as _TVV5T on  _TVV5T.kvgr5 = $projection.kvgr5
                                 and _TVV5T.spras = $session.system_language
{
  key _KNVV.kunnr,
      _KNVV.kvgr5,
      _KNVV.vkorg,
      _KNVV.vtweg,
      _KNVV.spart,
      _TVV5T.bezei,

      case
          when _KNVV.kvgr5 is initial then _TVV5T.bezei
          else concat( concat( _KNVV.kvgr5, '-'), _TVV5T.bezei )
      end as GrupoClienteAgenda
}
group by
  _KNVV.kunnr,
  _KNVV.vkorg,
  _KNVV.vtweg,
  _KNVV.spart,
  _KNVV.kvgr5,
  _TVV5T.bezei
