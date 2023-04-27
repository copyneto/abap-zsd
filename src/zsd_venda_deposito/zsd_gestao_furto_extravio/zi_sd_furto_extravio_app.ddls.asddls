@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'App para gestão de furto e extravio'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_FURTO_EXTRAVIO_APP
  as select from    I_SalesOrder          as _OrderDeb
    inner join      ZI_SD_OV_NOTA_ITEM    as _OrderDebItem on _OrderDebItem.SalesOrderDeb = _OrderDeb.SalesOrder
    inner join      ZI_SD_OV_NOTA_DEB     as _Param        on _Param.OrderTypeDeb = _OrderDeb.SalesOrderType

    left outer join ZI_SD_OV_ECOMMERCE_V2 as _SalesOrder   on _SalesOrder.PurchaseOrder = _OrderDeb.PurchaseOrderByCustomer
  //left outer join ZI_SD_MONITOR_REM  as _FlowRemessa  on _FlowRemessa.PrecedingDocument = _SalesOrder.PurchaseOrder

  //left outer join ZI_SD_OV_ECOMMERCE as _SalesOrder   on _SalesOrder.SalesOrder = _OrderDeb.SalesOrder
  //left outer join ZI_SD_MONITOR_REM  as _FlowRemessa  on _FlowRemessa.PrecedingDocument = _SalesOrder.SalesOrderEcommerce
  association        to ZI_SD_FAT_NOTA_DEB as _FaturaDeb on  _FaturaDeb.SalesDocument     = _OrderDeb.SalesOrder
                                                         and _FaturaDeb.SalesDocumentItem = _OrderDebItem.SalesOrderDebItem

  association [0..1] to I_Plant            as _Plant     on  _Plant.Plant = $projection.ShippingPoint
  association        to vbkd               as _Pedido    on  _Pedido.vbeln = $projection.SalesOrder

{
  key       _OrderDeb.SalesOrder                                   as SalesOrderDeb,
  key       _FaturaDeb.SubsequentDocument                          as SubsequentDocument,
            //_SalesOrder.SalesOrderEcommerce     as SalesOrder,
  key       _SalesOrder.SalesOrder,
            _SalesOrder.DistributionChannel                        as DistributionChannel,
            _SalesOrder.CreationDate                               as CreationDate,
            //_SalesOrder.PurchaseOrderByCustomer as PurchaseOrderByCustomer,
            //_SalesOrder.PurchaseOrder           as PurchaseOrderByCustomer,
//            _OrderDeb.PurchaseOrderByCustomer,
            _Pedido.bstkd                                          as PurchaseOrderByCustomer,
            //_FlowRemessa.BR_NFeNumber           as BR_NFeNumber,
            _SalesOrder.BR_NFeNumber,
            _FaturaDeb.SubsequentDocument                          as CorrespncExternalReference,
            _OrderDeb.SoldToParty                                  as Soldtoparty,
            _OrderDeb._SoldToParty.CustomerName                    as SoldtopartyName,
            _OrderDeb.SDDocumentReason                             as SDdocumentreason,
            _OrderDeb._SDDocumentReason._Text.SDDocumentReasonText as SDdocumentreasonText,
            _OrderDebItem.Plant                                    as ShippingPoint,
            _Plant.PlantName,
            //_FlowRemessa.Fatura                 as FaturaEcommerce,


            case
                 when _FaturaDeb.SubsequentDocument is not null then 'Completo'
                 else 'Andamento'
            end                                                    as Status,

            case
                 when _FaturaDeb.SubsequentDocument is not null  then 3 --Verde
                 else 2 --Amarelo
            end                                                    as StatusColor

}
group by
//_SalesOrder.SalesOrderEcommerce,
  _SalesOrder.SalesOrder,
  _OrderDeb.SalesOrder,
  _FaturaDeb.SubsequentDocument,
  _SalesOrder.DistributionChannel,
  _SalesOrder.CreationDate,
  //_SalesOrder.PurchaseOrderByCustomer,
  _SalesOrder.PurchaseOrder,
  //_FlowRemessa.BR_NFeNumber,
  _SalesOrder.BR_NFeNumber,
  _OrderDeb.CorrespncExternalReference,
  _OrderDeb.SoldToParty,
  _OrderDeb._SoldToParty.CustomerName,
  _OrderDeb.SDDocumentReason,
  _OrderDeb._SDDocumentReason._Text.SDDocumentReasonText,
  _OrderDebItem.Plant,
  _Plant.PlantName,
  //  _OrderDeb.PurchaseOrderByCustomer
  _Pedido.bstkd
//_FlowRemessa.Fatura
