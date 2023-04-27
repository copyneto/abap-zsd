@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '_TmEventsDescritptions /scmtms/c_ev_tyt'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity zi_sd_TmEventsDescritptions
  as select from /scmtms/c_ev_tyt
{
  key tor_event     as TorEvent,
  key langu         as Langu,
      description_s as DescriptionS
}
