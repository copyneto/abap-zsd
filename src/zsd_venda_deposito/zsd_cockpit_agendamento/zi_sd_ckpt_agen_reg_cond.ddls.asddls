@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Seleciona Nº de registro de condição'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_AGEN_REG_COND
  as select from    ZI_SD_ORDERS_ITEMS           as _OrdersItem
    left outer join I_SDDocumentCompletePartners as _Partners          on  _Partners.SDDocument      = _OrdersItem.SalesOrder
                                                                       and _Partners.PartnerFunction = 'WE'
    left outer join kotp100                      as _RecebidorMaterial on  _RecebidorMaterial.matnr = _OrdersItem.Material
                                                                       and _RecebidorMaterial.kunwe = _Partners.Customer
                                                                       and _RecebidorMaterial.datbi >= $session.system_date
                                                                       and _RecebidorMaterial.datab <= $session.system_date
                                                                       and _RecebidorMaterial.kschl = 'SHIP'

    left outer join kotp001                      as _Material          on  _Material.matnr = _OrdersItem.Material
                                                                       and _Material.datbi >= $session.system_date
                                                                       and _Material.datab <= $session.system_date
                                                                       and _Material.kschl = 'SHIP'
{
  key _OrdersItem.SalesOrder,
  key _OrdersItem.SalesOrderItem,
      _OrdersItem.Material,
      _OrdersItem.OrderQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      _OrdersItem.OrderQuantity,

      case
      when _RecebidorMaterial.knumh is not initial
      then _RecebidorMaterial.knumh
      else _Material.knumh
      end as RegCondicao

}
