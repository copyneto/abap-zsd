@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Detalhes do JOB'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_DET_JOBS_CTR
  as select from I_SalesContract as Contratos
  cross join ZI_SD_DET_JOBS_LOG  as _Job 
{
  key Contratos.SalesContract as Contrato,
      _Job.Modulo,
      _Job.Chave1,
      _Job.Chave2,
      _Job.Chave3,
      _Job.Sign,
      _Job.Opt,
      _Job.Low,
      _Job.Descricao,
      _Job.Status,
      _Job.NumeroJob,
      _Job.DataInicio,
      _Job.HoraInicio,
      _Job.DataFim,
      _Job.HoraFim
}
