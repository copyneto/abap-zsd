@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Event Ordem Frete'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #L,
    dataClass: #MIXED
}
define view entity zi_sd_remessa_frete_events
  as select from /scmtms/d_torrot           as _FreightOrder
    inner join   zi_sd_LastEexecutionDataTM as _LastEexecutionDataTM on _LastEexecutionDataTM.ParentKey = _FreightOrder.db_key
    inner join   /scmtms/d_torexe           as _ExecutionDataTM      on  _ExecutionDataTM.parent_key   = _FreightOrder.db_key
                                                                     and _ExecutionDataTM.actual_date  = _LastEexecutionDataTM.ActualDate
                                                                     and _ExecutionDataTM.execution_id = _LastEexecutionDataTM.ExecutionId
{
  key _FreightOrder.tor_id                as OrdemFrete,
      _ExecutionDataTM.event_code         as EventCode,
      max( _ExecutionDataTM.actual_date ) as ActualDate
}
where
      _FreightOrder.tor_id    is not initial
  and _FreightOrder.tor_cat   =  'TO'
  and _FreightOrder.lifecycle <> '10'
group by
  _FreightOrder.tor_id,
  _ExecutionDataTM.event_code
