@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Parâmetros de agrupamento de impostos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_RELEX_IMPOSTO as select from ztca_param_val {
 key low as Low,
 key chave3 as Chave3
/* key modulo as Modulo,
 key chave1 as Chave1,
 key chave2 as Chave2, */
 
}
 where modulo = 'SD'
   and chave1 = 'REL.EXP.LUCRO'
   and chave2 = 'IMPOSTO'
