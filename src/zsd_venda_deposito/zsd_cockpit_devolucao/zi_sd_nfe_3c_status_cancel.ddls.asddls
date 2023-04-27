@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Seleção de Nfes 3C Canceladas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_NFE_3C_STATUS_CANCEL
  as select from ZI_SD_COCKPIT_DEVOLUCAO_NFNUM as _Nfe3C
    inner join   j_1bnfe_active as _NfeActive on _NfeActive.docnum = _Nfe3C.DocNf
    inner join   ZI_SD_PARAM_STATUS_CNCL_NF    as _StatusNfe on _StatusNfe.StatusNf = _NfeActive.code
{
  key _Nfe3C.DocOrigem,
      _NfeActive.code 
}
