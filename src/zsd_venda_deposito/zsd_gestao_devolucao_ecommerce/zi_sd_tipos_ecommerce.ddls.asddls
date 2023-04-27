@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Tipo de ordem de devolução'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_TIPOS_ECOMMERCE as select from ztca_param_val  
{
  key modulo,
  key chave1,
  key chave2,
  key chave3,
  key cast( low as abap.char(4) ) as OrderType
} where modulo = 'SD'
    and chave1 = 'ECOMMERCE'
    and chave2 = 'TIPOS_OV_APP_DEV'
