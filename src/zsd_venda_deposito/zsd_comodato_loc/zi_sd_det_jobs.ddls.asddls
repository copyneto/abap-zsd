@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Comodato e locação - Detalhes do JOB'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_DET_JOBS
  as select from ZI_SD_DET_JOBS_CTR as DetalheJob
//  association to parent ZI_SD_COCKPIT_APP as _Cockpit on $projection.Contrato = _Cockpit.SalesContract
{
  key  Contrato,
  key  Modulo,
  key  Chave1, 
  key  Chave2,
  key  Chave3,
  key  Sign,
  key  Opt,
  key  Low,
       Descricao,
       Status,
       NumeroJob,
       DataInicio,
       HoraInicio,
       DataFim,
       HoraFim

       /* associations */
//       _Cockpit
} 
