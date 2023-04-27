@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Seleção na tabela de parâmetros'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZI_SD_MONITOR_PARAM
  with parameters
    p_modulo : ze_param_modulo,
    p_chave1 : ze_param_chave,
    p_chave2 : ze_param_chave
  as select from ztca_param_val
{
  key modulo,
  key chave1,
  key chave2,
  key chave3,
  key cast( low as abap.char(2) ) as parametro
}
where
      modulo = $parameters.p_modulo
  and chave1 = $parameters.p_chave1
  and chave2 = $parameters.p_chave2
