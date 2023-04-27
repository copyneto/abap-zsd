@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta Ordem de frete'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_FRETE
  with parameters
    p_cat : /scmtms/tor_category
  as select from /scmtms/d_tordrf as _DRF
    inner join   /scmtms/d_torrot as _ROT on  _ROT.db_key  = _DRF.parent_key
                                          and _ROT.tor_cat = $parameters.p_cat
//  association to ZI_SD_FRETE_EXE as _EXE on _EXE.parent_key = _DRF.parent_key //_ROT.db_key

  //    left outer join ZI_SD_CKPT_AGEN_PARAM( p_modulo : 'SD', p_chave1 : 'ADM_AGENDA', p_chave2 : 'DEL_EVENT' ) as _Param on _Param.parametro = _EXE.event_code


  // fazer left join na tabela /SCMTMS/D_TOREXE onde o parent_key =  db_key da torrot
  // e o EVENT_CODE = ao campo LOW da da tabela de parametros ZTCA_PARAM_VAL
{
  key right( _DRF.btd_id, 10) as SalesOrder,
      max( _ROT.tor_id    )   as OrdemFrete 

}
where
  _DRF.btd_tco = '73' //'114'
group by
  _DRF.btd_id
