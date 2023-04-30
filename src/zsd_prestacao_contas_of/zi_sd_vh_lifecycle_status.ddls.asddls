@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Help Search: Ciclo de vida (Status)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
@Search.searchable: true
define view entity ZI_SD_VH_LIFECYCLE_STATUS
  as select from I_TranspOrdLifeCycleStatus
{
      @ObjectModel.text.element: ['TranspOrdLifeCycleStatusDesc']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
   key TranspOrdLifeCycleStatus,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
  _Text[ 1:Language = $session.system_language ].TranspOrdLifeCycleStatusDesc
  }
 
