@AbapCatalog.sqlViewName: 'ZISD_ORDTYPEDEV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Help Search: Tipo da Ordem'
@Search.searchable: true
define view ZI_SD_VH_ORDERTYPE_DEV
  as select from tvak                  as Tvak
    inner join   ZI_SD_PARAM_TP_OV_DEV as _TipoOrdem on _TipoOrdem.TpOrdem = tvak.auart
  association to tvakt as _Text on  _Text.auart = $projection.SalesDocumentType
                                and _Text.spras = $session.system_language

{
      @ObjectModel.text.element: ['Text']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
  key auart       as SalesDocumentType,
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Text.bezei as Text,
      @UI.hidden: true
      sperr       as Block
}
