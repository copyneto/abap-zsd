@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca dos valores do código do beneficio'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_SD_CBENEF_ENTITY
  as select from j_1bnfe_cb_icms as J_1BNFE_CB_ICMS
  association to j_1bnfe_cb_icmst as _Text on  _Text.regio  = $projection.Regio
                                           and _Text.cbenef = $projection.Cbenef
                                           and _Text.langu  = $session.system_language
{
      @ObjectModel.text.element: ['Text']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
  key regio                  as Regio,
      @ObjectModel.text.element: ['Text']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
  key j_1bnfe_cb_icms.cbenef as Cbenef,
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Text.cbenef_text      as Text

}
