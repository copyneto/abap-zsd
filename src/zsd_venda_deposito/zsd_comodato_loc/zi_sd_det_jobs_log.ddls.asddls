@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Detalhes do JOB - Log'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_DET_JOBS_LOG
  as select from ZI_CA_PARAM_VAL as Param
  association [0..*] to ZI_SD_DET_JOBS_RUN as _Job on _Job.NomeJob = $projection.Low
{
  Param.Modulo    as Modulo,
  Param.Chave1    as Chave1,
  Param.Chave2    as Chave2,
  Param.Chave3    as Chave3,
  Param.Sign      as Sign,
  Param.Opt       as Opt,
  Param.Low       as Low,
  Param.Descricao as Descricao,
  _Job.NomeJob    as NomeJob,
  _Job.Status     as Status,
  _Job.NumeroJob  as NumeroJob,
  _Job.DataInicio as DataInicio,
  _Job.HoraInicio as HoraInicio,
  _Job.DataFim    as DataFim,
  _Job.HoraFim    as HoraFim
}
where
      Modulo = 'SD'
  and Chave1 = 'CONTRATOS FOOD'
  and Chave2 = 'JOBS'
