@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ov Item Nota'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_OV_NOTA_ITEM
  as select from I_SalesOrder     as _OrderDeb
    inner join   I_SalesOrderItem as _OrderDebItem on _OrderDebItem.SalesOrder = _OrderDeb.SalesOrder
{
  key       _OrderDeb.SalesOrder                as SalesOrderDeb,
            min( _OrderDebItem.SalesOrderItem ) as SalesOrderDebItem,
            _OrderDebItem.Plant
}
group by
  _OrderDeb.SalesOrder,
  _OrderDebItem.Plant
