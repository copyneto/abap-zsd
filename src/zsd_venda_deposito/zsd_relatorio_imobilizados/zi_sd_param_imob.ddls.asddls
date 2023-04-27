@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Parâmetro imobilizados'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_PARAM_IMOB
  as select from ztca_param_val
{
  key modulo,
  key chave1,
  key chave2,
  key chave3,
  key cast( low as abap.char(4) ) as fkart
}
where
      modulo = 'SD'
  and chave1 = 'RELATÓRIO IMOBILI'
  and chave2 = 'TIPO DE ATIVO'
  and chave3 = 'COMODATO'
