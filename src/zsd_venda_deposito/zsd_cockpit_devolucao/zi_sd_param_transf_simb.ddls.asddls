@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Parametro Motivo Tranferencia'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_PARAM_TRANSF_SIMB 
as select from ztca_param_val {
  key modulo,
  key chave1,
  key chave2,
  key chave3,
  key cast( low as abap.char(3) ) as TpMov
    
} where modulo = 'SD'
    and chave1 = 'ADM DEVOLUÇÃO'
    and chave2 = 'MVM_DF'
