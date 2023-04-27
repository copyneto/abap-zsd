@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta Ordem de frete'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_ORDEM_FRETE
  with parameters
    p_tipo_doc : /scmtms/btd_type_code,
    p_catg_doc : /scmtms/tor_category

  as select from /scmtms/d_tordrf as _TorDrf
  association to /scmtms/d_torrot   as _TorId on _TorId.db_key = $projection.ParentKey

{
  _TorDrf.parent_key as ParentKey,
  case
    when _TorDrf.btd_tco = '73' then right( _TorDrf.btd_id, 10)
    else right( _TorId.base_btd_id, 10 )
    end              as Remessa,
  _TorId.tor_id      as DocumentoFrete

}
where
      _TorDrf.btd_tco = $parameters.p_tipo_doc
  and _TorId.tor_cat  = $parameters.p_catg_doc
