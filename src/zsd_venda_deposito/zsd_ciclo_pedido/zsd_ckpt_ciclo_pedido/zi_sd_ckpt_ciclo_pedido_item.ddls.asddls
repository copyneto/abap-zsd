@AbapCatalog.sqlViewName: 'ZVSDCKPTITMPED'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dados do Item'
define view ZI_SD_CKPT_CICLO_PEDIDO_ITEM as select distinct from I_SalesOrderItem as _salesorderitem {
    
    key _salesorderitem.SalesOrder,
        _salesorderitem.Route,
        _salesorderitem.Plant
    
}
