@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Event Ordem Frete'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REMESSA_FRETE_EVENT 
  as select from /scmtms/d_torrot as _ROT
    inner join   /scmtms/d_tordrf as _DRF on  _ROT.db_key  = _DRF.parent_key
                                          and _DRF.btd_tco = '73'
    inner join   /scmtms/d_torexe as _EXE on _EXE.parent_key = _DRF.parent_key 
{
  key  _ROT.tor_id             as OrdemFrete,
       max( _EXE.actual_date ) as Data,
       max( _EXE.execution_id ) as Id


}
where
  _ROT.tor_cat = 'TO'
group by
  _ROT.tor_id
