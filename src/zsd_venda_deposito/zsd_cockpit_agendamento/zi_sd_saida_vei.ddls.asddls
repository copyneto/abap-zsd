@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Status Saída do Veículo'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_SAIDA_VEI
  with parameters
    p_cat : /scmtms/tor_category
  as select from    /scmtms/d_tordrf as _DRF
    inner join      /scmtms/d_tordrf as _DRF1 on _DRF1.db_key = _DRF.db_key
                                             and _DRF1.btd_tco = '73'  
    inner join      /scmtms/d_torrot as _ROT on  _ROT.db_key  = _DRF.parent_key
                                             and _ROT.tor_cat = $parameters.p_cat
    left outer join /scmtms/d_torexe as _EXE on  _EXE.parent_key = _ROT.db_key
                                             and _EXE.event_code = 'CHECK_OUT'

{
  key right( _DRF.btd_id, 10) as SalesOrder,
      _ROT.tor_id as OrdemFrete,
      _EXE.event_code as EventCode
}
group by 
_DRF.btd_id,
_ROT.tor_id,
_EXE.event_code 
