@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Seleção de Nfes 3C Canceladas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_NFE_IN_STATUS_CANCEL
  as select from /xnfe/innfehd              as _NfeIn
    inner join   ZI_SD_PARAM_STATUS_CNCL_NF as _StatusNfe on _StatusNfe.StatusNf = _NfeIn.statcod
{
  key _NfeIn.nfeid,
      _NfeIn.statcod,
      _NfeIn.cnpj_emit,
      _NfeIn.nnf

}
