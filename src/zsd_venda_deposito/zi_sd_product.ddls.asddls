@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Basic View - PRODUCT Help Search'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #S,
    dataClass: #MIXED
}


@ObjectModel.representativeKey: 'Material'
@Search.searchable: true

define view entity ZI_SD_PRODUCT  
  as select from mara as Product
  association to makt as _Text on  _Text.matnr = $projection.Material
                                and _Text.spras = $session.system_language
{
      @ObjectModel.text.element: ['Descricao']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key matnr       as Material,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Text.maktx as Descricao
    
}
