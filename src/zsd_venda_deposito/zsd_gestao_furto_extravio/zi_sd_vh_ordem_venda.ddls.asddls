@AbapCatalog.sqlViewName: 'ZISD_OVECOMMERCE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Ordem de Venda'
@Search.searchable: true
define view ZI_SD_VH_ORDEM_VENDA
  as select from I_SalesOrder   as SalesOrder
    inner join   ZI_SD_PARAM_OV as _Param on _Param.OrderType = SalesOrder.SalesOrderType
{
      @Search.defaultSearchElement: true
  key SalesOrder as SalesOrder

}
