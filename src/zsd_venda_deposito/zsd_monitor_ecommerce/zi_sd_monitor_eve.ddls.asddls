@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Paramentro Evento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_MONITOR_EVE as select from ztca_param_val 
{
  key modulo,
  key chave1,
  key chave2,
  key chave3,
  key cast( low as abap.char(20)) as EventCode
} where modulo = 'SD'
    and chave1 = 'ECOMMERCE'
    and chave2 = 'TIPO_EVENTO_SAIDA'
