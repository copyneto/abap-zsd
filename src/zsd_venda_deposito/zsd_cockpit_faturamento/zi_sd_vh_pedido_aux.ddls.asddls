@AbapCatalog.sqlViewName: 'ZVSDPEDAUX'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help Pedido Aux'
@Search.searchable: true
define view ZI_SD_VH_PEDIDO_AUX
  as select from I_SalesOrder
{
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key SalesOrder,
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      CorrespncExternalReference
}
where
  CorrespncExternalReference is not initial
