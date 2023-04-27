@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help Mês'
//@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@Search.searchable: true
define view entity ZI_SD_VH_COMEX_MES
  as select from t009c
  {

        @EndUserText.label: 'Id'
        @Search.ranking: #MEDIUM
        @Search.defaultSearchElement: true
        @Search.fuzzinessThreshold: 0.8
    key poper as Mes,

        @EndUserText.label: 'Mês do Ano'
        @Semantics.text: true
        @Search.defaultSearchElement: true
        @Search.ranking: #HIGH
        @Search.fuzzinessThreshold: 0.7
        ktext as Descricao
  }
  where
    periv = 'K0' and
    spras = $session.system_language
