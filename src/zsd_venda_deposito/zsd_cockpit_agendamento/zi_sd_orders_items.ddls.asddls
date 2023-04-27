@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Orders e Itens'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_ORDERS_ITEMS
  as select from I_SalesOrder as I_Order
  association        to I_SalesOrderItem     as _Item    on  $projection.SalesOrder         =  _Item.SalesOrder
                                                         and (
                                                            _Item.SalesDocumentRjcnReason   =  ''
                                                            or(
                                                              _Item.SalesDocumentRjcnReason <> ''
                                                              and(
                                                                _Item.DeliveryStatus        =  'B'
                                                                or _Item.DeliveryStatus     =  'C'
                                                              )
                                                            )
                                                          )
  association [1..1] to ZI_SD_CKPT_AGEN_VEND as _Partner on  $projection.SalesOrder = _Partner.SDDocument
  association [1..1] to knvv                 as _Grupo   on  _Grupo.kunnr = I_Order.SoldToParty
                                                         and _Grupo.vkorg = I_Order.SalesOrganization
                                                         and _Grupo.vtweg = I_Order.DistributionChannel
                                                         and _Grupo.spart = I_Order.OrganizationDivision

  association [1..1] to kna1                 as _Cliente on  _Cliente.kunnr = I_Order.SoldToParty
{
  key SalesOrder,
  key _Item.SalesOrderItem,
      SoldToParty,
      PurchaseOrderByCustomer,
      RequestedDeliveryDate,
      I_Order.CreationDate,
      SalesOrganization,
      DistributionChannel,
      OrganizationDivision,
      CustomerAccountAssignmentGroup,
      _Item.SalesOrder  as SalesOrderI,
      _Item.Plant       as Plant,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      _Item.ItemGrossWeight,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      _Item.ItemNetWeight,
      _Item.ItemWeightUnit,
      _Item.Material,
      _Item.SalesOrderItemText,
      @Semantics.quantity.unitOfMeasure: 'ItemVolumeUnit'
      _Item.ItemVolume,
      @ObjectModel.foreignKey.association: 'ItemVolumeUnit'
      _Item.ItemVolumeUnit,
      _Item.OrderQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      _Item.OrderQuantity,
      _Item.SalesDocumentRjcnReason,
      _Item.TransactionCurrency,
      OverallSDProcessStatus,

      SalesOrderType,
      SalesGroup,
      SalesDistrict,
      _Item.Route       as Route,
      CustomerPurchaseOrderDate,
      _Partner.Supplier as Supplier,
      _Grupo.kvgr5,
      _Cliente.regio,
      _Cliente.ort01,
      _Cliente.ort02,
      _Cliente.name1    as SoldToPartyName,
      @EndUserText.label: 'Tipo de Exibição'
      //      ' '                   as Tipo_exibicao,
      /* Associations */
      _Item,
      _Partner,
      _Grupo,
      _Cliente
}
