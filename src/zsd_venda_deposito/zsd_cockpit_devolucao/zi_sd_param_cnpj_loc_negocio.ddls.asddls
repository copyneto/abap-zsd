@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Parametro para buscar CNPJ do Cliente'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_PARAM_CNPJ_LOC_NEGOCIO as select from ztca_param_val 
{
  key modulo,
  key chave1,
  key chave2,
  key chave3,
  key cast( low  as abap.char(4) ) as LocalNegocio,
  key cast( high as abap.char(18) ) as Cnpj
    
} where modulo = 'SD'
    and chave1 = 'ADM DEVOLUÇÃO'
    and chave2 = 'CNPJ_LOC_DE_NEGÓCIO'
