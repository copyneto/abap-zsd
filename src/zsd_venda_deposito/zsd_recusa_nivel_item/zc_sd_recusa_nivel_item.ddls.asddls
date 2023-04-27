@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Adm. Motivo de Recusa'
define root view entity ZC_SD_RECUSA_NIVEL_ITEM
  as select from    I_SalesOrder                   as _Header
    inner join      I_SalesOrderItem               as _ItemOrder         on _ItemOrder.SalesOrder = _Header.SalesOrder

  //    left outer join ZC_SD_USER                     as A          on _Header.SalesOrder = A.objectid
    left outer join ZC_SD_SDDocumentCompletePart   as _Partners          on _Partners.SDDocument = _ItemOrder.SalesOrder
    left outer join ZC_SD_SalesOrderPricingElement as _Pricing           on  _Pricing.PricingDocument     = _ItemOrder.SalesOrderCondition
                                                                         and _Pricing.PricingDocumentItem = _ItemOrder.SalesOrderItem

    left outer join t006a                          as _UnidadeMedidaText on  _UnidadeMedidaText.msehi = _ItemOrder.OrderQuantityUnit
                                                                         and _UnidadeMedidaText.spras = $session.system_language

  //  association [0..1] to ZI_SD_MOTVREC_CHANGE_RECUS as _ChgRec     on  _ChgRec.SalesOrder     = $projection.SalesOrder
  //                                                                  and _ChgRec.SalesOrderItem = $projection.SalesOrderItem

  association [0..1] to I_SalesDocumentTypeText    as _Text       on  $projection.SalesOrderType = _Text.SalesDocumentType
                                                                  and _Text.Language             = $session.system_language
  association [0..1] to ZI_CA_VH_GBSTK             as _StatusText on  _StatusText.Gbstk = $projection.OverallSDProcessStatus
  association [0..1] to ZI_CA_VH_ABGRU             as _MotvText   on  _MotvText.SalesDocumentRjcnReason = $projection.motivoRecusa

  association [0..1] to ZI_SD_MOTVREC_CHANGE_RECUS as _ChgRec     on  _ChgRec.SalesOrder     = _ItemOrder.SalesOrder
                                                                  and _ChgRec.SalesOrderItem = _ItemOrder.SalesOrderItem


{
      @EndUserText.label: 'Documento de vendas'
  key _Header.SalesOrder,
  key _ItemOrder.SalesOrderItem,
      @EndUserText.label: 'Material'
      _ItemOrder.Material,
      @EndUserText.label: 'Descrição Material'
      _ItemOrder._MaterialText[1: Language = $session.system_language ].MaterialName,
      @Consumption.filter.mandatory: true
      _ItemOrder.Plant,
      @EndUserText.label: 'Quantidade da Ordem de Venda'
      cast(_ItemOrder.OrderQuantity as abap.dec( 15, 3 ))  as OrderQuantity,
      @EndUserText.label: 'Unidade da Ordem de Venda'
      //      @ObjectModel.text.element: ['UnMedidaText']
      _ItemOrder.OrderQuantityUnit,
      _UnidadeMedidaText.msehl                             as UnMedidaText,
      cast(_ItemOrder.NetPriceAmount as abap.dec( 11, 2 )) as NetPriceAmount,
      _ItemOrder.TransactionCurrency,
      _ItemOrder.NetPriceQuantity,
      _ItemOrder.NetPriceQuantityUnit,
      _ItemOrder.SDProcessStatus,
      //      @ObjectModel.text.element: ['SalesDocumentTypeName']
      @EndUserText.label: 'Tipo de doc.vendas'
      _Header.SalesOrderType,
      @EndUserText.label: 'Descrição tipo pedido cliente'
      //      _Header._SalesOrderType._Text[1: Language = $session.system_language ].SalesDocumentTypeName,
      _Text.SalesDocumentTypeName,
      //      @Consumption.hidden: true
      @Consumption.filter.mandatory: true
      @EndUserText.label: 'Organização de vendas'
      _Header.SalesOrganization,
      //      @Consumption.hidden: true
      _Header.DistributionChannel,
      //      @Consumption.hidden: true
      _ItemOrder.Division,
      //      @Consumption.hidden: true
      @EndUserText.label: 'Número do Pedido'
      _ItemOrder.PurchaseOrderByShipToParty,
      @EndUserText.label: 'Referência do Cliente'
      _ItemOrder.PurchaseOrderByCustomer,
      //      @Consumption.hidden: true
      @EndUserText.label: 'Status da ordem'
      @ObjectModel.text.element: ['StatusText']
      _Header.OverallSDProcessStatus                       as OverallSDProcessStatus,
      //      @Consumption.hidden: true
      @EndUserText.label: 'Usuário'
      _Header.CreatedByUser                                as UserID,
      @EndUserText.label: 'Emissor da ordem'
      @ObjectModel.text.element: ['CustomerName']
      _Header.SoldToParty                                  as Customer,
      @EndUserText.label: 'Nome do emissor da ordem'
      _Header._SoldToParty.CustomerName                    as CustomerName,
      //      @EndUserText.label: 'Referência do Cliente'
      //      _Header.PurchaseOrderByCustomer,
      //      @Consumption.hidden: true
      _Header.SalesOrderDate,
      @Consumption.hidden: true
      _Header.SalesOrderCondition                          as SalesOrderCondition,
      //      @ObjectModel.text.element: ['SalesDocumentRjcnReasonName']
      //      _ItemOrder.SalesDocumentRjcnReason,
      //      _ItemOrder._SalesDocumentRjcnReason._Text[1: Language = $session.system_language ].SalesDocumentRjcnReasonName,
      //      @Consumption.hidden: true
      @EndUserText.label: 'Data desejada de remessa'
      _Header.RequestedDeliveryDate,
      //      @Consumption.hidden: true
      _ItemOrder.SalesDistrict,
      //      @Consumption.hidden: true
      _Header.SalesOffice,
      @EndUserText.label: 'Motivo de recusa'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_ABGRU', element: 'SalesDocumentRjcnReason' } }]
      //      @ObjectModel.text.element: ['SalesDocumentRjcnReasonName']
      _ItemOrder.SalesDocumentRjcnReason,
      @EndUserText.label: 'Descrição da Recusa'
      _ItemOrder._SalesDocumentRjcnReason._Text[1: Language = $session.system_language ].SalesDocumentRjcnReasonName,
      @EndUserText.label: 'Data modificação'
      _ChgRec.DataModificacao                              as DataModificacaoRecusa,
      @EndUserText.label: 'Usuário modificação'
      _ChgRec.ModificadoPor                                as UserModificacaoRecusa,
      //      @Consumption.hidden: true
      //      @UI.hidden: true
      //
      //      ''                                  as motivoRecusa,
      @EndUserText.label: 'Vendedor'
      @ObjectModel.text.element: ['NomeVendedor']
      _Partners.Supplier                                   as Vendedor,
      _Partners.SupplierName                               as NomeVendedor,
      //      @Consumption.hidden: true
      //      A.username                          as username,
      //      @Consumption.hidden: true
      //      A.udate                             as Udate,
      //      @Consumption.hidden: true
      @EndUserText.label: 'Desconto'
      _Pricing.ConditionAmount                             as VlrDesconto,
      //      @Consumption.hidden: true
      @EndUserText.label: 'Peso bruto'
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      _ItemOrder.ItemGrossWeight                           as PesoBruto,
      @EndUserText.label: 'Grupo de Cliente'
      _ItemOrder.CustomerGroup                             as GrupoCliente,
      @Consumption.hidden: true
      _ItemOrder.ItemWeightUnit,

      //Associations
      //      _Header._OverallSDProcessStatus                      as _OverallSDProcessStatus,
      _Header._SoldToParty                                 as _SoldToParty,
      _Header._SalesOrderType                              as _SalesOrderType,
      _ItemOrder._SalesDistrict                            as _SalesDistrict,
      //      _itemorder._SalesDocumentRjcnReason                  as _SalesDocumentRjcnReason,
      //      _ItemOrder._ItemWeightUnit
      cast('' as abap.char( 2 ) )                          as motivoRecusa,
      _StatusText.Descricao                                as StatusText,
      _Text,
//      _MotvText,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      @EndUserText.label: 'Peso Líquido'
      _ItemOrder.ItemNetWeight                             as PesoLiquido
}
