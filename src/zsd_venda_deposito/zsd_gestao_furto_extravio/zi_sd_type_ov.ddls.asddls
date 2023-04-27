@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Parâmetros com os tipos de Ordens'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_TYPE_OV
  as select from ztca_param_val
{
  key modulo,
  key chave1,
  key chave2,
  key chave3,
  key cast( low as abap.char(4) ) as OrderType
}
where
      modulo = 'SD'
  and chave1 = 'ECOMMERCE'
  and chave2 = 'TIPOS_OV'
