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
define view entity ZI_SD_VH_REMESSA_PARVW
  as select from    tpar           as Parceiro

    inner join      ztca_param_val as _Param on  _Param.modulo = 'SD'
                                             and _Param.chave1 = 'ADM_FATURAMENTO'
                                             and _Param.chave2 = 'PARVW_VEND'
                                             and _Param.chave3 = ''
                                             and _Param.sign   = 'I'
                                             and _Param.opt    = 'EQ'
                                             and _Param.low    = Parceiro.parvw

    left outer join tpart          as _Text  on  _Text.parvw = Parceiro.parvw
                                             and _Text.spras = $session.system_language


{
  @ObjectModel.text.element: ['PartnerFunctionName']
  @Search.ranking: #MEDIUM
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.8
  key cast ( Parceiro.parvw as abap.char(2) ) as PartnerFunction,
  @Semantics.text: true
  @Search.defaultSearchElement: true
  @Search.ranking: #HIGH
  @Search.fuzzinessThreshold: 0.7
  _Text.vtext                             as PartnerFunctionName

}
