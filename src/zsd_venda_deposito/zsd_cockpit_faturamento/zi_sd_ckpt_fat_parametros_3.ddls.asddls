@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'SD Parametros'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_FAT_PARAMETROS_3 
    with parameters p_chave1 : ze_param_chave,
                    p_chave2 : ze_param_chave,
                    p_chave3 : ze_param_chave
as select from ztca_param_val 
{
  key modulo,
  key chave1,
  key chave2,
  key chave3,
  key cast( low as abap.char(4) ) as parametro
} where modulo = 'SD'
    and chave1 = $parameters.p_chave1
    and chave2 = $parameters.p_chave2
    and chave3 = $parameters.p_chave3
