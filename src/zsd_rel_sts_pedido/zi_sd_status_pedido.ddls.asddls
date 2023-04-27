@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Intfc. - Relatório Status do Pedido'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_STATUS_PEDIDO
  as select from I_SalesOrder     as _SalesOrder

    inner join   I_SalesOrderItem as _SalesOrderItem on  _SalesOrderItem.SalesOrder     = _SalesOrder.SalesOrder
                                                     and _SalesOrderItem.SalesOrderItem = '000010'
  association to vbak                      as _Vbak         on _Vbak.vbeln = _SalesOrder.SalesOrder

  //  //Remessa
  //    left outer join I_SDDocumentProcessFlow           as _deliveryDoc    on  _deliveryDoc.PrecedingDocument          = _SalesOrder.SalesOrder
  //                                                                         and _deliveryDoc.SubsequentDocumentCategory = 'J'
  //                                                                         and _deliveryDoc.SubsequentDocumentItem     = _SalesOrderItem.SalesOrderItem
  //
  //  //Fatura
  //    left outer join I_SDDocumentProcessFlow           as _faturaDoc      on  _faturaDoc.PrecedingDocument          = _deliveryDoc.SubsequentDocument
  //                                                                         and _faturaDoc.SubsequentDocumentCategory = 'M'
  //                                                                         and _faturaDoc.SubsequentDocumentItem     = _SalesOrderItem.SalesOrderItem
  //
  //  //Ordem de frete
  //    left outer join ZI_SD_STATUS_FRETE (p_cat : 'TO') as _OrdFrete       on _OrdFrete.SalesOrder = concat('0000000000000000000000000',_deliveryDoc.SubsequentDocument)
  //

  //    join         ZI_FI_STATUS_CUST_ADDR  as _CustomerAddr   on _CustomerAddr.kunnr = _Customer.Customer

  association to ZI_SD_STATUS_REM          as _FlowRemessa  on _FlowRemessa.PrecedingDocument = _SalesOrder.SalesOrder
  //                                                   and _FlowRemessa.PrecedingDocument = $projection.SubsequentDocument

  //  association to ZI_SD_STATUS_CUST         as _Customer     on _Customer.SDDocument = $projection.Sales_Order
  association to I_Customer                as _Customer     on _Customer.Customer = $projection.Sold_ToParty

  association to ZI_FI_STATUS_CUST_ADDR    as _CustomerAddr on _CustomerAddr.kunnr = $projection.Sold_ToParty

  //association to ZI_FI_STATUS_MOTORISTA    as _Motorista    on _Motorista.vbeln = $projection.Sales_Order


  association to ZI_SD_STATUS_RECUSA_TEXT  as _DescRecusa   on _DescRecusa.vbeln = $projection.Sales_Order

  //CDS para Vendedor Interno
  association to ZI_SD_STATUS_VENDEDOR     as _VendedorInt  on _VendedorInt.vbeln = $projection.Sales_Order

  //CDS para Vendedor Externo
  association to ZI_SD_STATUS_VENDEDOR_EXT as _VendedorExt  on _VendedorExt.vbeln = $projection.Sales_Order
  //                                                               and _Vendedor.PartnerFunction = 'ZI'
  //                                                               or  _Vendedor.PartnerFunction = 'ZE'

  //  association to ZI_SD_STATUS_FAT as _FaturaeNF on _FaturaeNF.SubsequentDocument = $projection.FaturaDoc
  //  association to ZFI_FI_STAT_MOTORISTA    as _MotoristaText    on _MotoristaText.partner = $projection.motorista
{

  key _SalesOrder.SoldToParty                 as Sold_ToParty,
  key _SalesOrder.SalesOrder                  as Sales_Order,
      //      _deliveryDoc.SubsequentDocument         as SubsequentDocument,//Remessa
  key _FlowRemessa.DeliveryDocument           as DocRemessa, //Remessa
      _FlowRemessa.Fatura                     as FaturaDoc,
      _FlowRemessa.OrdemFrete                 as OrdemFrete,
      //      _faturaDoc.SubsequentDocument           as FaturaDoc,
      _FlowRemessa.SubsequentDocumentCategory as SubsequentDocumentCategory,
      //      _faturaDoc.SubsequentDocumentCategory   as FaturaDocCat,
      _FlowRemessa.DocFatCateg                as FaturaDocCat,

      _SalesOrder.SalesOrganization           as Sales_Organization,
      _SalesOrder.DistributionChannel         as Dist_Channel,
      _SalesOrder.SalesOffice                 as Sales_Office,
      _SalesOrder.SalesDistrict               as Sales_District,
      _SalesOrder.PurchaseOrderByCustomer     as Purchase_OrderCust,
      @Consumption.valueHelpDefinition: [ { entity:  { name: 'ZI_CA_VH_BSARK', element: 'BSARK' } }]
      _SalesOrder.CustomerPurchaseOrderType   as Cust_PurchaseOrder,
      _SalesOrder.SDDocumentReason            as SD_DocReason,
      _SalesOrder.ShippingCondition           as Shipping_Cond,
      _SalesOrder.SalesOrderType              as Sales_OrderType,
      _SalesOrder.CustomerPaymentTerms        as Cust_PaymentTerms,
      _SalesOrder.CustomerPurchaseOrderDate   as Cust_PurchaseOrderDate,
      _SalesOrder.CreationDate                as Creation_Date,
      _SalesOrder.PurchaseOrderByShipToParty  as Purch_ShipToParty,
      _SalesOrder.DeliveryBlockReason         as Delivery_BlockReason,
      @Consumption.valueHelpDefinition: [ { entity:  { name: 'ZI_SD_VH_STATUS_GLOBAL_OV', element: 'StatusGlobalOv' } }]
      _SalesOrder.OverallSDProcessStatus      as StatusOV,

      //SalesOrderItem
      _SalesOrderItem.SalesOrderItem          as SalesOrderItem,
      _SalesOrderItem.Plant                   as Plant,
      _SalesOrderItem.ShippingPoint           as Ship_Point,
      _SalesOrderItem.SalesDocumentRjcnReason as Sales_DocRjcnReason,
      _DescRecusa.DescMotivoRecusa            as DescMotivoRecusa,

      //_FlowRemessa.SubsequentDocument,
      //_FlowRemessa.SubsequentDocumentCategory,

      _FlowRemessa.CreationDate, //dt ordem de frete

      _FlowRemessa.CreationDate               as CreationDateFatura,
      //      _FlowRemessa.BillingDocument,
      _FlowRemessa.BR_NFeNumber,
      _FlowRemessa.BR_NFAuthenticationDate,
      _FlowRemessa.BR_NotaFiscal,
      _FlowRemessa.BR_NFNetAmount,
      _FlowRemessa.BR_NFPostingDate,
      @Semantics.quantity.unitOfMeasure: 'HeaderWeightUnit'
      _FlowRemessa.HeaderNetWeight,
      @Semantics.quantity.unitOfMeasure: 'HeaderWeightUnit'
      _FlowRemessa.HeaderGrossWeight,
      _FlowRemessa.HeaderWeightUnit,
      _FlowRemessa.BR_NFIsPrinted,
      //      _FlowRemessa.BR_CFOPCode,

      _FlowRemessa.CreationDateRemessa,
      _FlowRemessa.DeliveryDocument,
      _FlowRemessa.ShippingConditionName,

      _VendedorInt.lifnr                      as VendedorInt,
      _VendedorExt.lifnr                      as VendedorExt,

      //_Customer.PartnerFunction,
      _Customer.CustomerName                  as CustomerPartnerDescription,
      _Customer.Region                        as Region,
      _Customer.CityName                      as CityName,

      //      _CustomerAddr.CEP,
      _Customer.PostalCode                    as CEP,
      _CustomerAddr.DomFiscal,

      _FlowRemessa.Motorista,
      //_FlowRemessa.Motorista
      _Vbak.vsnmr_v                           as Matricula

}
