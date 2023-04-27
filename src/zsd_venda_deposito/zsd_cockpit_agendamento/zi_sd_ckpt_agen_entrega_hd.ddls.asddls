@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS main agenda header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_AGEN_ENTREGA_HD
  //  as select from ZI_SD_ORDERS_ITEMS as I_Sales
  as select from    I_SalesOrder            as I_Sales
    inner join      I_SalesOrderItem        as _Item     on  I_Sales.SalesOrder            = _Item.SalesOrder
                                                         and _Item.SalesDocumentRjcnReason = ''
    left outer join ZI_SD_CKPT_AGEN_REMESSA as I_Remessa on I_Remessa.SalesOrder = I_Sales.SalesOrder

{
  key I_Sales.SalesOrder,

  key I_Remessa.Document,
      min( I_Remessa.Item )       as Item,
      min( _Item.SalesOrderItem ) as SalesOrderItem,
      _Item.TransactionCurrency
}
where
  I_Sales.OverallSDDocumentRejectionSts <> 'C'
group by
  I_Sales.SalesOrder,
  I_Remessa.Document,
  _Item.TransactionCurrency
