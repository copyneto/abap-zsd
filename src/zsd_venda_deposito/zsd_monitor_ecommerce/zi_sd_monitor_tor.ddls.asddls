@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ordem de frete'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_MONITOR_TOR
  with parameters
    p_tipo_doc : /scmtms/btd_type_code,
    p_catg_doc : /scmtms/tor_category

  as select from /scmtms/d_tordrf as _TorDrf
  association to ZI_SD_MONITOR_EXEC as _Exec  on _Exec.ParentKey = $projection.ParentKey
  association to /scmtms/d_torrot   as _TorId on _TorId.db_key = $projection.ParentKey

{
  _TorDrf.parent_key                                                                                            as ParentKey,
  case
    when _TorDrf.btd_tco = '73' then right( _TorDrf.btd_id, 10)
    else right( _TorId.base_btd_id, 10 )
    end                                                                                                         as Remessa,
  _TorId.tor_id                                                                                                 as DocumentoFrete,
  //  _Exec.ActualDate                                                                                             as ActualDate,
  _TorId.created_on                                                                                             as ActualDate,
  _Exec.EventCode                                                                                               as EventCode,
  _Exec.ExtLocId                                                                                                as ExtLocId,

  tstmp_to_dats(_TorId.created_on,abap_system_timezone( $session.client,'INITIAL' ),$session.client,'INITIAL')  as DateSaida,
  tstmp_to_tims(_TorId.created_on,abap_system_timezone( $session.client,'INITIAL' ),$session.client,'INITIAL' ) as HoraSaida,
  //  tstmp_to_dats(_Exec.ActualDate,abap_system_timezone( $session.client,'INITIAL' ),$session.client,'INITIAL') as DateSaida,
  //  tstmp_to_tims(_Exec.ActualDate,abap_system_timezone( $session.client,'INITIAL' ),$session.client,'INITIAL' ) as HoraSaida,
  _TorId.lifecycle
}
where
      _TorDrf.btd_tco = $parameters.p_tipo_doc
  and _TorId.tor_cat  = $parameters.p_catg_doc
