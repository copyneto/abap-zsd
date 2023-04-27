@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Execution Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #L,
  dataClass: #MIXED
}
define view entity zi_sd_LastEexecutionDataTM
  as select from zi_sd_execution_data_tm as _Execution
{
  key ParentKey,
      max( ActualDate )  as ActualDate,
      max( ExecutionId ) as ExecutionId
}
group by
  ParentKey
