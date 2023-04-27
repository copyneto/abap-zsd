@AbapCatalog.sqlViewName: 'ZI_SD_DT_STS_OF'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data do ultimo status Ordem de Frete'
define view ZI_SD_DATA_STS_FN_OF
  with parameters
    p_evento1 : /scmtms/tor_event,
    p_evento2 : /scmtms/tor_event,
    p_evento3 : /scmtms/tor_event,
    p_evento4 : /scmtms/tor_event,
    p_evento5 : /scmtms/tor_event,
    p_evento6 : /scmtms/tor_event,
    p_evento7 : /scmtms/tor_event
  as select from ZI_TM_STS_ATUAL_OF
{
  key IdOrdemFrete     as IdOrdemFrete,
      CodigoOrdemFrete as CodigoOrdemFrete,
      max(Data)        as Data
}
where
  (
        Evento = $parameters.p_evento1
    and Evento is not initial
  ) 
  or(
        Evento = $parameters.p_evento2
    and Evento is not initial
  )
  or(
        Evento = $parameters.p_evento3
    and Evento is not initial
  ) 
  or(
        Evento = $parameters.p_evento4
    and Evento is not initial
  ) 
  or(
        Evento = $parameters.p_evento5
    and Evento is not initial
  ) 
  or(
        Evento = $parameters.p_evento6
    and Evento is not initial
  ) 
  or(
        Evento = $parameters.p_evento7
    and Evento is not initial
  ) 
  
group by
  IdOrdemFrete,
  CodigoOrdemFrete
