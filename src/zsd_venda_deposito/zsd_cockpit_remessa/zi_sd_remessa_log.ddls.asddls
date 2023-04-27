@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Mensagem  de log'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REMESSA_LOG
  as select from ztsd_cp_rem_log
{
  key vbeln_vl as OutboundDelivery,
  key line     as Line,
      msgty    as Msgty,
      msgid    as Msgid,
      msgno    as Msgno,
      msgv1    as Msgv1,
      msgv2    as Msgv2,
      msgv3    as Msgv3,
      msgv4    as Msgv4,
      message  as Message
}
