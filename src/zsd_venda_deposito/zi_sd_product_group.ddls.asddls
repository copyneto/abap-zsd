@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Help Search Grupo Mercadorias'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #S,
    dataClass: #MIXED
}

@ObjectModel.representativeKey: 'GrpMercadorias'
@Search.searchable: true

define view entity ZI_SD_PRODUCT_GROUP  as select from t023 as ProductGroup
  association to t023t as _Text on  _Text.matkl = $projection.GrpMercadorias
                                and _Text.spras = $session.system_language
{
      @ObjectModel.text.element: ['Descricao']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key matkl       as GrpMercadorias,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Text.wgbez as Descricao
 }
    
