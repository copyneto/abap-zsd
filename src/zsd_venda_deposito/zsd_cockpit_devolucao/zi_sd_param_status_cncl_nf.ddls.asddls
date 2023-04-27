@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Selecionar na tabela de parâmetros'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_PARAM_STATUS_CNCL_NF as select from ztca_param_val 
{
  key modulo,
  key chave1,
  key chave2,
  key chave3,
  key cast( low as abap.char(4)) as StatusNf
} where modulo = 'SD'
    and chave1 = 'ADM DEVOLUÇÃO'
    and chave2 = 'STATUS_CANCEL_NF'
