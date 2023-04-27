@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Parametros tipo de ov coleta avarias'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity zi_sd_coleta_avarias_tp_ov_par
  as select from ztca_param_val
{
  key modulo,
  key chave1,
  key chave2,
  key chave3,
  key cast( low as auart ) as OrderType
}
where
      modulo = 'SD'
  and chave1 = 'COLETA_AVARIA'
  and chave2 = 'AUART'
