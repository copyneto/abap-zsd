@AbapCatalog.sqlViewName: 'ZVSDTVTG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help Motivo do desvio da data'
@Search.searchable: true
define view ZI_SD_VH_VSTGA
  as select from tvtg  as _tvtg
    inner join   tvtgt as _texto on  _texto.vstga = _tvtg.vstga
                                 and _texto.spras = $session.system_language
{
       @ObjectModel.text.element: ['Texto']
       @Search.ranking: #MEDIUM
       @Search.defaultSearchElement: true
       @Search.fuzzinessThreshold: 0.8
       @EndUserText.label      : 'Movito Agenda'
  key  _texto.vstga as Motivo,
       @Semantics.text: true
       @Search.defaultSearchElement: true
       @Search.ranking: #HIGH
       @Search.fuzzinessThreshold: 0.7
       _texto.bezei as Texto
}
