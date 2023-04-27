@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Log'
@Metadata.ignorePropagatedAnnotations: true
//@Search.searchable: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_05_LOG
  as select from ztsd_interco_log as _Log
  association to parent zi_sd_01_cockpit as _cockpit on _cockpit.Guid = $projection.Guid
{
  key _Log.guid                  as Guid,
  key _Log.seqnr                 as Seqnr,
      _Log.msgty                 as Msgty,
      _Log.msgid                 as Msgid,
      _Log.msgno                 as Msgno,
      _Log.msgv1                 as Msgv1,
      _Log.msgv2                 as Msgv2,
      _Log.msgv3                 as Msgv3,
      _Log.msgv4                 as Msgv4,
      _Log.message               as Message,
      _cockpit
}
