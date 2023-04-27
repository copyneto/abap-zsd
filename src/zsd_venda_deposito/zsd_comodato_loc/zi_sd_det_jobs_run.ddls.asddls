@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Detalhes do JOB - Jobs em execução'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_DET_JOBS_RUN
  as select from tbtco
{
  jobname  as NomeJob,
  status   as Status,
  jobcount as NumeroJob,
  strtdate as DataInicio,
  strttime as HoraInicio,
  enddate  as DataFim,
  endtime  as HoraFim
}
where
     status = 'R'
  or status = 'Y'
  or status = 'P'
  or status = 'R'

//  running       = 'R',
//  ready         = 'Y',
//  scheduled     = 'P',
//  released      = 'S',
//  aborted       = 'A',
//  finished      = 'F',
//  put_active    = 'Z',
//  unknown_state = 'X'.
