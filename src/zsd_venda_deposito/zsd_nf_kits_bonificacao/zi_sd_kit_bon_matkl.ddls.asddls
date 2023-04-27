@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Grupo de mercadoria dos Kit Bonificação'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_KIT_BON_MATKL as select from ztca_param_val 
{
  key modulo,
  key chave1,
  key chave2,
  key chave3,
  key cast( low as abap.char(3) ) as GrupoMerca
} where modulo = 'SD'
    and chave1 = 'BON_KIT'
    and chave2 = 'MVGR4'
    
