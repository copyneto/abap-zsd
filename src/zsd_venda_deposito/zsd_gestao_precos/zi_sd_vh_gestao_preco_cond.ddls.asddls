@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Lista de condições'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
@Search.searchable: true
define view entity ZI_SD_VH_GESTAO_PRECO_COND

  as select from t682i as _Condition
  
    inner join   dd02t as _Table on  _Table.tabname    = concat( _Condition.kvewe, _Condition.kotabnr )
                                 and _Table.ddlanguage = $session.system_language
                                 and _Table.as4local   = 'A'

{
      @ObjectModel.text.element: ['PriceTableText']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key concat( _Condition.kvewe, _Condition.kotabnr ) as PriceTable,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Table.ddtext                                  as PriceTableText
}

where
      _Condition.kvewe = 'A'
  and _Condition.kappl = 'V'
