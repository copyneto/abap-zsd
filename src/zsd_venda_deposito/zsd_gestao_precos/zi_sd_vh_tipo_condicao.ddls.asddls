@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Tipo de condição'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_SD_VH_TIPO_CONDICAO

  as select from t685  as _ConditionType

    inner join   t685t as _Text on  _Text.spras = $session.system_language
                                and _Text.kvewe = _ConditionType.kvewe
                                and _Text.kappl = _ConditionType.kappl
                                and _Text.kschl = _ConditionType.kschl


{
      @ObjectModel.text.element: ['ConditionTypeText']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key _ConditionType.kschl as ConditionType,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Text.vtext                                  as ConditionTypeText
}

where
      _ConditionType.kvewe = 'A'
  and _ConditionType.kappl = 'V'
