@AbapCatalog.sqlViewName: 'ZSD_AGEND_HIST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS historico máx2'
define view ZI_SD_CKPT_AGEN_HIST2 
as select distinct from ZI_SD_CKPT_AGEN_HIST
{
    key Ordem,
    key Remessa,
    key NfE,
    key DataAgendada,
    key HoraAgendada,
    Senha,
    Agend_Valid,
    DataHoraAgendada,
    motivo,
    Texto,
    observacoes
}
group by  
  Ordem,
  Remessa,
 NfE,
  Senha,
  DataAgendada,
  HoraAgendada,
  Agend_Valid,
  motivo,
  Texto,
  observacoes,
  DataHoraAgendada
