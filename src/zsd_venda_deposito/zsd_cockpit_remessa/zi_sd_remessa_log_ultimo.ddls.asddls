@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Última mensagem  de log'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REMESSA_LOG_ULTIMO
  as select from ztsd_cp_rem_log as _UltimoLog

  association [0..1] to ZI_SD_REMESSA_LOG as _Log on  _Log.OutboundDelivery = $projection.OutboundDelivery
                                                  and _Log.Line             = $projection.Line

{
  key vbeln_vl  as OutboundDelivery,
      max(line) as Line,
      _Log
}
group by
  vbeln_vl
