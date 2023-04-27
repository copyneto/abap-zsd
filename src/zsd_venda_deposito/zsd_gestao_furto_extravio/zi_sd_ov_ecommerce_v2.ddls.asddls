@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ordem de Venda e-commerce'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_OV_ECOMMERCE_V2
  //as select from ZI_SD_MONITOR_APP as _Ecommerce
  as select from    ZI_SD_OV_PEDIDO       as _Ref
    left outer join ZI_SD_MONITOR_APP     as _Ecommerce on _Ecommerce.PurchaseOrder = _Ref.Referencia
    inner join      ZI_SD_TIPOS_ECOMMERCE as _Tip       on _Ecommerce.SalesOrderType = _Tip.OrderType
  //left outer join vbfa as _OrdemDeb on _Ecommerce.SalesOrder = _OrdemDeb.vbelv
  //left outer join I_SalesOrder as _SalesEcommerce on _SalesEcommerce.SalesOrder = _OrdemDeb.vbelv
{
  key _Ecommerce.SalesOrder,
      //  key _Ecommerce.PurchaseOrder,
  key _Ref.PurchaseOrderByCustomer as PurchaseOrder,
      _Ref.Referencia,
      _Ecommerce.DistributionChannel,
      _Ecommerce.CreationDate,
      _Ecommerce.NfeNumDisplay     as BR_NFeNumber,
      _Ecommerce.FaturaDisplay     as FaturaEcommerce
      //_OrdemDeb.vbelv as SalesOrderEcommerce,
      //_SalesEcommerce.PurchaseOrderByCustomer,
      //_SalesEcommerce.DistributionChannel,
      //_SalesEcommerce.CreationDate
}
group by
  _Ecommerce.SalesOrder,
  _Ref.PurchaseOrderByCustomer,
  //  _Ecommerce.PurchaseOrder,
  _Ref.Referencia,
  _Ecommerce.DistributionChannel,
  _Ecommerce.CreationDate,
  _Ecommerce.NfeNumDisplay,
  _Ecommerce.FaturaDisplay
//_OrdemDeb.vbelv,
//_SalesEcommerce.PurchaseOrderByCustomer,
//_SalesEcommerce.DistributionChannel,
//_SalesEcommerce.CreationDate
