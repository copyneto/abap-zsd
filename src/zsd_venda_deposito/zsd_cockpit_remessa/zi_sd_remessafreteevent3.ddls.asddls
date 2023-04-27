@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Event Ordem Frete'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #L,
    dataClass: #MIXED
}
define view entity zi_sd_RemessaFreteEvent3
  as select from /scmtms/d_torrot as _TorRoot
  association [0..1] to zi_sd_LastEexecutionDataTM as _LastEexecutionDataTM on _LastEexecutionDataTM.ParentKey = _TorRoot.db_key
{
  key _TorRoot.tor_id                   as OrdemFrete,
      _TorRoot.db_key                   as DbKey,
      _LastEexecutionDataTM.ActualDate  as ActualDate,
      _LastEexecutionDataTM.ExecutionId as ExecutionId
}
