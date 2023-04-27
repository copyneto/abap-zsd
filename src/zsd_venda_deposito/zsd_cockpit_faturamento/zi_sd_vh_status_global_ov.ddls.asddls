@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Help Search: Status Global Ordem Venda'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_VH_STATUS_GLOBAL_OV
  as select from I_OverallSDProcessStatusText
{
      @ObjectModel.text.element: ['StatusGlobalOvTexto']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key OverallSDProcessStatus     as StatusGlobalOv,

      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      OverallSDProcessStatusDesc as StatusGlobalOvTexto
}
where
  Language = $session.system_language
