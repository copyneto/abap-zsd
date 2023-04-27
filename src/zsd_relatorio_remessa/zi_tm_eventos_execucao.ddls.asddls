@AbapCatalog.sqlViewName: 'ZITMEVENTEXEC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Obtendo evento atual'
define view ZI_TM_EVENTOS_EXECUCAO
  as select from /scmtms/d_torrot as OrdemFrete
    inner join   /scmtms/d_torexe as Event on Event.parent_key = OrdemFrete.db_key
{
  key OrdemFrete.tor_id,
  key max( Event.actual_date ) as ACTUAL_DATE,
      Event.event_code as event_code
}
group by 
  OrdemFrete.tor_id,
  Event.event_code
