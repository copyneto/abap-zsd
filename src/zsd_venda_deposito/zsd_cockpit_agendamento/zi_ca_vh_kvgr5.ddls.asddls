@AbapCatalog.sqlViewName: 'ZSEARCH_KVGR5'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help Agrupamento'
@Search.searchable: true
define view ZI_CA_VH_KVGR5
  //  as select from knvv as _knvv
  //    inner join   tvv5 as _tvv5 on _knvv.kvgr5 = _tvv5.kvgr5
  as select from tvv5  as _tvv5
    inner join   tvv5t as _texto on  _texto.kvgr5 = _tvv5.kvgr5
                                 and _texto.spras = $session.system_language
{
      @ObjectModel.text.element: ['Texto']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key _texto.kvgr5 as Agrupamento,
  key _texto.bezei as Texto

}
