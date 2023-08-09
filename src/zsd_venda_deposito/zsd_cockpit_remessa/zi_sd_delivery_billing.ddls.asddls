@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SD delivery first item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #L,
  dataClass: #MIXED
}
define view entity zi_sd_delivery_billing
  as select from zi_sd_delivery_first_item as _SDDeliveryFirstItem
  association [0..1] to ZI_SD_REMESSA_BILLING as _Billing on  _Billing.SalesDocument           = $projection.SalesDocument
                                                          and _Billing.SalesDocumentItem       = $projection.SalesDocumentFirstItem
                                                          and _Billing.ReferenceSDDocument     = $projection.DeliveryDocument
                                                          and _Billing.ReferenceSDDocumentItem = $projection.DeliveryDocumentFirstItem
{
  key SalesDocument,
  key DeliveryDocument,
      SalesDocumentFirstItem,
      DeliveryDocumentFirstItem,
      _Billing.BillingDocument,
      _Billing.BillingDocumentItem,

      _Billing
}
//    left outer join I_BR_NFItem               as _NFItem  on  _NFItem.BR_NFSourceDocumentType   = 'BI'
//                                                          and _NFItem.BR_NFSourceDocumentNumber = _Billing.BillingDocument
//                                                          and _NFItem.BR_NFSourceDocumentItem   = _Billing.BillingDocumentItem
//
//  association [0..1] to ZI_SD_REMESSA_INFO_ORDEM_FRETE as _FreightOrder     on  _FreightOrder.DeliveryDocument = $projection.DeliveryDocument
//
//  association [0..1] to vbkd                           as _vbkd             on  _vbkd.vbeln = $projection.SalesDocument
//                                                                            and _vbkd.posnr = '000000'
//
//  association [0..1] to likp                           as _OutboundDelivery on  _OutboundDelivery.vbeln = $projection.DeliveryDocument
//  association [0..1] to lips                           as _DeliveryItem     on  _DeliveryItem.vbeln = $projection.DeliveryDocument
//                                                                            and _DeliveryItem.posnr = $projection.DeliveryDocumentFirstItem
//
//  association [0..1] to vbak                           as _SalesOrder       on  _SalesOrder.vbeln = $projection.SalesDocument
//  association [0..1] to vbap                           as _SalesOrderItem   on  _SalesOrderItem.vbeln = $projection.SalesDocument
//                                                                            and _SalesOrderItem.posnr = $projection.SalesDocumentFirstItem
//  association [0..1] to I_BR_NFDocument                as _NFHeader         on  _NFHeader.BR_NotaFiscal = _NFItem.BR_NotaFiscal
//
//{
//  key _SDDeliveryFirstItem.SalesDocument,
//  key _SDDeliveryFirstItem.DeliveryDocument,
//      _SDDeliveryFirstItem.SalesDocumentFirstItem,
//      _SDDeliveryFirstItem.DeliveryDocumentFirstItem,
//
//      _Billing.BillingDocument,
//      _Billing.BillingDocumentItem,
//      _Billing.AccountingPostingStatus,
//      _Billing.BillingDocumentDate,
//      _Billing.BillingDocumentCategory,
//      _Billing.BillingDocumentType,
//
//      cast( _NFItem.BR_NotaFiscal as abap.char(10) )                as BR_NotaFiscal,
//      _NFItem._BR_NotaFiscal.BR_NFeNumber                           as BR_NFeNumber2,
//
//      _vbkd.bzirk                                                   as SalesDistrict,
//
//      ltrim( _FreightOrder.FreightOrder, '0' )                      as FreightOrder,
//      _FreightOrder.FreightOrder                                    as FreightOrderComplete,
//      _FreightOrder.CreatedOn                                       as CreatedOn,
//
//
//      _SalesOrder.auart                                             as SalesOrderType,
//      _SalesOrder.kunnr                                             as SoldToParty,
//      @Semantics.amount.currencyCode: 'TransactionCurrency'
//      _SalesOrder.netwr                                             as TotalNetAmount,
//      _SalesOrder.waerk                                             as TransactionCurrency,
//      _SalesOrder.bstdk                                             as CustomerPurchaseOrderDate,
//      _SalesOrder.vtweg                                             as DistributionChannel,
//      _SalesOrder.vkbur                                             as SalesOffice,
//      _SalesOrder.vkgrp                                             as SalesGroup,
//      _SalesOrder.kvgr5                                             as AdditionalCustomerGroup5,
//      _SalesOrder.lfstk                                             as OverallDeliveryStatus,
//      _SalesOrder.erdat                                             as CreationDate,
//      cast( _SalesOrder.erzet as creation_time preserving type )    as CreationTime,
//      cast(_SalesOrder.vdatu as reqd_delivery_date preserving type) as RequestedDeliveryDate,
//
//      _SalesOrderItem.lprio                                         as DeliveryPriority,
//      _SalesOrderItem.route                                         as Route,
//
//      _OutboundDelivery.kostk                                       as OverallPickingStatus,
//      _OutboundDelivery.erdat                                       as DeliveryCreationDate,
//      _OutboundDelivery.erzet                                       as DeliveryCreationTime,
//      _OutboundDelivery.lifsk                                       as DeliveryBlockReason,
//      _OutboundDelivery.wbstk                                       as OverallGoodsMovementStatus,
//
//      _DeliveryItem.werks                                           as Plant,
//
//      _NFHeader.BR_NFType                                           as BR_NFType,
//      _NFHeader.BR_NFDocumentType                                   as BR_NFDocumentType,
//      _NFHeader.BR_NFDirection                                      as BR_NFDirection,
//      _NFHeader.BR_NFModel                                          as BR_NFModel,
//      _NFHeader.CreationDate                                        as NFCreationDate,
//      _NFHeader.CreationTime                                        as NFCreationTime,
//      _NFHeader.BR_NFIsPrinted                                      as BR_NFIsPrinted,
//      _NFHeader.BR_NFeDocumentStatus                                as BR_NFeDocumentStatus
//}
