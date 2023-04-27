@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Verifica se o centro é um depósito fechado'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COCKPIT_DEVOLUCAO_DF 
 as select from ztsd_devolucao as _Devolucao
inner join ZI_SD_PARAM_DEVOLUCAO_DF as _Param on _Param.Centro = _Devolucao.centro
{
  key _Devolucao.ord_devolucao as OrdemDevolucao,
  key _Devolucao.centro        as Centro
  
} 
