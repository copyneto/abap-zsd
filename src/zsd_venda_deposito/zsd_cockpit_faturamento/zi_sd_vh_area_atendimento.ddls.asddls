@AbapCatalog.sqlViewName: 'ZVSDKATR9'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Help Search: Área atendimento'
@Search.searchable: true
define view ZI_SD_VH_AREA_ATENDIMENTO
  as select from tvk9  as _TVK9
    inner join   tvk9t as _TVK9T on  _TVK9.katr9  = _TVK9T.katr9
                                 and _TVK9T.spras = $session.system_language
{
      @ObjectModel.text.element: ['AreaAtendimentoTexto']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key _TVK9.katr9  as AreaAtendimento,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _TVK9T.vtext as AreaAtendimentoTexto
}
