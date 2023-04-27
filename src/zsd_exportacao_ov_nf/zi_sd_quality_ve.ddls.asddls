@AbapCatalog.sqlViewName: 'ZI_V_QUALITY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Virtual Element do campo Quality'

define view ZI_SD_QUALITY_VE 
as select from I_SalesOrderItem as _SalesOrderItem {
    key right(_SalesOrderItem.SalesOrder, 10) as SalesOrder,
    key right(_SalesOrderItem.SalesOrderItem, 6) as SalesOrderItem,


    cast( '<virtual>'  as abap.char(255))  as Quality
}
