@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'SD Parametros'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_FAT_PARAM_ORDENS
  as select from ztca_param_val
{
  key modulo,
  key chave1,
  key chave2,
  key chave3,
  key cast( low as abap.char(1) ) as parametro
}
where
      modulo = 'SD'
  and chave1 = 'ADM_FATURAMENTO'
  and chave2 = 'STATUS_GLOBAL_OV'
  and chave3 = ' '
