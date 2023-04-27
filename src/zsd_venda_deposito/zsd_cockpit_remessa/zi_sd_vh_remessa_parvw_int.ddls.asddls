@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Função parceiro'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_SD_VH_REMESSA_PARVW_INT
  as select from    tpar           as Parceiro

    inner join      ztca_param_val as _Param on  _Param.modulo = 'SD'
                                             and _Param.chave1 = 'ADM_FATURAMENTO'
                                             and _Param.chave2 = 'PARVW_VEND'
                                             and _Param.chave3 = 'INTERNO'
                                             and _Param.low    = Parceiro.parvw
{
  @Search.ranking: #MEDIUM
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.8
  key max ( cast ( Parceiro.parvw as abap.char(2) ) ) as PartnerFunction
}
