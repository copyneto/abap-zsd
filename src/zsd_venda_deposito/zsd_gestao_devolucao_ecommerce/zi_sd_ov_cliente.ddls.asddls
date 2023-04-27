@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Parametro de Ordem Cliente'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_OV_CLIENTE
  as select from ztca_param_val as _Param
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
  and chave2 = 'TIPO_ORDEM_DEV'
