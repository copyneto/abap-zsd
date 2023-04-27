@AbapCatalog.sqlViewName: 'ZI_SD_ULT_STS_OF'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Último status da Ordem de frete'
define view ZI_SD_STS_FN_OF
  with parameters
    p_evento1 : /scmtms/tor_event,
    p_evento2 : /scmtms/tor_event,
    p_evento3 : /scmtms/tor_event,
    p_evento4 : /scmtms/tor_event,
    p_evento5 : /scmtms/tor_event,
    p_evento6 : /scmtms/tor_event,
    p_evento7 : /scmtms/tor_event
  as select from ZI_TM_STS_ATUAL_OF as t1
  association [1..1] to ZI_SD_DATA_STS_FN_OF as _Status on t1.IdOrdemFrete = _Status.IdOrdemFrete
{
  key t1.IdOrdemFrete     as IdOrdemFrete,
      t1.CodigoOrdemFrete as CodigoOrdemFrete,
      t1.Evento,
      
      tstmp_to_tims( 
        _Status(
               p_evento1 : $parameters.p_evento1,
               p_evento2 : $parameters.p_evento2,
               p_evento3 : $parameters.p_evento3,
               p_evento4 : $parameters.p_evento4,
               p_evento5 : $parameters.p_evento5,
               p_evento6 : $parameters.p_evento6,
               p_evento7 : $parameters.p_evento7 ).Data,
                     abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                                           $session.client,
                                           'NULL' )  as Hora,
      
      _Status( p_evento1 : $parameters.p_evento1,
               p_evento2 : $parameters.p_evento2,
               p_evento3 : $parameters.p_evento3,
               p_evento4 : $parameters.p_evento4,
               p_evento5 : $parameters.p_evento5,
               p_evento6 : $parameters.p_evento6,
               p_evento7 : $parameters.p_evento7 ).Data
}
where
  t1.Data = _Status( p_evento1 : $parameters.p_evento1,
                     p_evento2 : $parameters.p_evento2,
                     p_evento3 : $parameters.p_evento3,
                     p_evento4 : $parameters.p_evento4,
                     p_evento5 : $parameters.p_evento5,
                     p_evento6 : $parameters.p_evento6,
                     p_evento7 : $parameters.p_evento7 ).Data
