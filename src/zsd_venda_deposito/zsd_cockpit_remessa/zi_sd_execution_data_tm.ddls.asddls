@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Execution Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #L,
  dataClass: #MIXED
}
define view entity zi_sd_execution_data_tm
  as select from /scmtms/d_torexe as _TorExe
{
  key db_key       as Dbkey,
      parent_key   as ParentKey,
      event_code   as EventCode,
      actual_date  as ActualDate,
      execution_id as ExecutionId
}
