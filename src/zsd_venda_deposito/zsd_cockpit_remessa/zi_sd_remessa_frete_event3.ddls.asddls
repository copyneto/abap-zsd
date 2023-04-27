@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Event Ordem Frete'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #L,
    dataClass: #MIXED
}
define view entity ZI_SD_REMESSA_FRETE_EVENT3
  as select from zi_sd_RemessaFreteEvent3 as _RemessaFreteEvent3
  association [1] to zi_sd_execution_data_tm as _EexecutionDataTM on  _EexecutionDataTM.ParentKey   = _RemessaFreteEvent3.DbKey
                                                                  and _EexecutionDataTM.ActualDate  = _RemessaFreteEvent3.ActualDate
                                                                  and _EexecutionDataTM.ExecutionId = _RemessaFreteEvent3.ExecutionId
{
  key _RemessaFreteEvent3.OrdemFrete,
      _EexecutionDataTM.EventCode,
 max( _EexecutionDataTM.ActualDate ) as ActualDate
}
group by
  OrdemFrete,
  _EexecutionDataTM.EventCode
