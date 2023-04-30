@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Veículo'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_SD_VH_PLACAS
  as select from    equi as Equipment
    left outer join eqkt as _Text on  _Text.equnr = Equipment.equnr
                                  and _Text.spras = $session.system_language
{
      @ObjectModel.text.element: ['PlacaText']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @EndUserText: {label: 'Placa', quickInfo: 'Placa'}
  key Equipment.equnr as Placa,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      @EndUserText: {label: 'Desc. Placa', quickInfo: 'Descrição da Placa'}
      _Text.eqktx     as PlacaText

}
where
    Equipment.eqtyp = 'C'
or Equipment.eqtyp = 'J'
or Equipment.eqtyp = 'T'
or Equipment.eqtyp = 'K'
