@AbapCatalog.sqlViewName: 'ZVSDKATR1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Help Search: Serviço Cliente'
@Search.searchable: true
define view ZI_SD_VH_CUSTOMER_SERVICE
  as select from tvk1  as _TVK1
    inner join   tvk1t as _TVK1T on  _TVK1.katr1  = _TVK1T.katr1
                                 and _TVK1T.spras = $session.system_language
{
      @ObjectModel.text.element: ['ServicoClienteTexto']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key _TVK1.katr1  as ServicoCliente,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _TVK1T.vtext as ServicoClienteTexto
}
