@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'App Verifica Utilização'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_VERIF_UTIL_APP
  as select from    I_SalesOrderItem                                   as _Item

    inner join      I_SalesOrder                                       as _Cab        on _Cab.SalesOrder = _Item.SalesOrder

    inner join      ZI_SD_CKPT_FAT_PARAMETROS( p_chave1 : 'ADM_FATURAMENTO',
                                                p_chave2 : 'TIPOS_OV') as _Param      on _Param.parametro = _Cab.SalesOrderType

    left outer join vbbe                                               as _CheckStock on  _CheckStock.vbeln = _Item.SalesOrder
                                                                                      and _CheckStock.posnr = _Item.SalesOrderItem
                                                                                      and _CheckStock.vbtyp = 'C'

  association to vbkd                        as _Ctr                       on  _Ctr.vbeln = $projection.SalesOrder
                                                                           and _Ctr.posnr = $projection.SalesOrderItem
  association to mara                        as _mat                       on  _mat.matnr = $projection.Material
  association to makt                        as _matx                      on  _matx.matnr = $projection.Material
                                                                           and _matx.spras = $session.system_language
  association to tvakt                       as _TpOrdem                   on  _TpOrdem.auart = $projection.SalesOrderType
                                                                           and _TpOrdem.spras = $session.system_language

  association to I_SalesDocumentScheduleLine as _Doc                       on  _Doc.SalesDocument     = $projection.SalesOrder
                                                                           and _Doc.SalesDocumentItem = $projection.SalesOrderItem

  association to ZI_SD_CKPT_FAT_PARTNER      as _Partner                   on  _Partner.SDDocument = $projection.SalesOrder

  association to ZI_SalesDocumentQuiqkView   as _ZI_SalesDocumentQuickView on  _ZI_SalesDocumentQuickView.SalesDocument = $projection.SalesOrder
{
  key _Item.SalesOrder,
  key _Item.SalesOrderItem,
      @ObjectModel.text.element: ['DescriptionMaterial']
      _Item.Material,
      _Item.Plant,
      _matx.maktx                as DescriptionMaterial,
      _mat.ean11                 as Ean,
      @ObjectModel.text.element: ['CustomerName']
      _Partner.Customer,
      _Partner.CustomerName,
      _Cab.SalesOrderType,
      _TpOrdem.bezei             as NameSalesOrderType,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      _Item.OrderQuantity,
      _Item.OrderQuantityUnit,
      _mat.meins                 as UMbase,

      // Data agendada
      _Doc.RequestedDeliveryDate as DataFat,
      _Cab.SalesOrganization,
      _Cab.DistributionChannel,
      _Cab.PriceListType,
      _Item.StorageLocation,

      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      _CheckStock.omeng          as Qtdebase,

      _ZI_SalesDocumentQuickView
}
where
  _CheckStock.omeng is not initial
group by
  _Item.SalesOrder,
  _Item.SalesOrderItem,
  _Item.Material,
  _Item.Plant,
  _matx.maktx,
  _mat.ean11,
  _Partner.Customer,
  _Partner.CustomerName,
  _Cab.SalesOrderType,
  _TpOrdem.bezei,
  _Item.OrderQuantity,
  _Item.OrderQuantityUnit,
  _mat.meins,
  _Doc.RequestedDeliveryDate,
  _Cab.SalesOrganization,
  _Cab.DistributionChannel,
  _Cab.PriceListType,
  _Item.StorageLocation,
  _CheckStock.omeng
