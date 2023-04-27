@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Parametro para Buscar NF de entrada'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CONTR_LOC_NF_ENTRA_PARAM
  as select from ztca_param_val
{
  key modulo,
  key chave1,
  key chave2,
  key chave3,
  key cast( low as abap.char(4) ) as Tp_Doc
}
where
      modulo = 'SD'
  and chave1 = 'CATEGORIA NFE'
  and chave2 = 'TP_COMODATO'
