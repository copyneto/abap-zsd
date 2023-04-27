@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Help Search: Centro Parâmetros'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_SD_VH_WERKS_PAR as select from t001w as _Centro 
    inner join ZI_SD_WERKS_ECOMMERCE_PAR as _Par on _Centro.werks = _Par.Werks
{
      @ObjectModel.text.element: ['WerksCodeName']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  @EndUserText.label: 'Centro'
  key _Centro.werks as WerksCode,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      @EndUserText.label: 'Nome do Centro'
      _Centro.name1 as WerksCodeName    
}
