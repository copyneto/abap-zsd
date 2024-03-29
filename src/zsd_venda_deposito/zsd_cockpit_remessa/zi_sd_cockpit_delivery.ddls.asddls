@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SD delivery first item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #L,
  dataClass: #MIXED
}

define view entity zi_sd_cockpit_delivery
  as select from zi_sd_delivery_filtered as _SDDeliveryFiltered


  association [0..1] to ZI_SD_REMESSA_INFO_ORDEM_VENDA as _Sales                       on  _Sales.SalesDocument = $projection.SalesDocument

  ////  association [0..1] to ZI_SD_REMESSA_FRETE_EVENT3     as _Frete                       on  _Frete.OrdemFrete = $projection.FreightOrderComplete
  //  association [0..1] to zi_sd_remessa_frete_events     as _Frete                       on  _Frete.OrdemFrete = $projection.FreightOrderComplete


  association [0..1] to ZI_SD_REMESSA_INFO_PARC_INT    as _VendorInt                   on  _VendorInt.SalesOrder = $projection.SalesDocument
  association [0..1] to ZI_SD_REMESSA_INFO_PARC_EXT    as _VendorExt                   on  _VendorExt.SalesOrder = $projection.SalesDocument
  association [0..1] to ZI_VH_SD_LPRIO                 as _Lprio                       on  _Lprio.DeliveryPriority = $projection.DeliveryPriority
  association [0..1] to ZI_SD_REMESSA_LOG_ULTIMO       as _Log                         on  _Log.OutboundDelivery = $projection.OutboundDelivery


  association [0..1] to ZI_CA_VH_NFTYPE                as _NFType                      on  _NFType.BR_NFType = $projection.BR_NFType
  association [0..1] to ZI_CA_VH_DOCTYP_NF             as _NFDocumentType              on  _NFDocumentType.BR_NFDocumentType = $projection.BR_NFDocumentType


  association [0..1] to I_SalesDocumentTypeText        as _SalesDocumentTypeText       on  _SalesDocumentTypeText.SalesDocumentType = $projection.SalesOrderType
                                                                                       and _SalesDocumentTypeText.Language          = $session.system_language
  association [0..1] to I_SalesDistrictText            as _SalesDistrictText           on  _SalesDistrictText.SalesDistrict = $projection.SalesDistrict
                                                                                       and _SalesDistrictText.Language      = $session.system_language
  association [0..1] to I_AccountingPostingStatusText  as _AccountingPostingStatusText on  _AccountingPostingStatusText.AccountingPostingStatus = $projection.accountingpostingstatus
                                                                                       and _AccountingPostingStatusText.Language                = $session.system_language
  association [0..1] to I_BillingDocumentCategoryText  as _BillingDocumentCategoryText on  _BillingDocumentCategoryText.BillingDocumentCategory = $projection.billingdocumentcategory
                                                                                       and _BillingDocumentCategoryText.Language                = $session.system_language
  association [0..1] to I_BillingDocumentTypeText      as _BillingDocumentTypeText     on  _BillingDocumentTypeText.BillingDocumentType = $projection.billingdocumenttype
                                                                                       and _BillingDocumentTypeText.Language            = $session.system_language
  association [0..1] to I_DeliveryBlockReasonText      as _DeliveryBlockReasonText     on  _DeliveryBlockReasonText.DeliveryBlockReason = $projection.DeliveryBlockReason
                                                                                       and _DeliveryBlockReasonText.Language            = $session.system_language
  association [0..1] to I_OverallGoodsMovementStatusT  as _OverallGoodsMovementStatusT on  _OverallGoodsMovementStatusT.OverallGoodsMovementStatus = $projection.OverallGoodsMovementStatus
                                                                                       and _OverallGoodsMovementStatusT.Language                   = $session.system_language
  association [0..1] to I_Customer                     as _SoldToParty                 on  _SoldToParty.Customer = $projection.SoldToParty
  association [0..1] to I_DistributionChannelText      as _DistributionChannelText     on  _DistributionChannelText.DistributionChannel = $projection.DistributionChannel
                                                                                       and _DistributionChannelText.Language            = $session.system_language
  association [0..1] to I_SalesOfficeText              as _SalesOfficeText             on  _SalesOfficeText.SalesOffice = $projection.SalesOffice
                                                                                       and _SalesOfficeText.Language    = $session.system_language
  association [0..1] to I_SalesGroupText               as _SalesGroupText              on  _SalesGroupText.SalesGroup = $projection.SalesGroup
                                                                                       and _SalesGroupText.Language   = $session.system_language
  association [0..1] to I_AdditionalCustomerGroup5Text as _AdditionalCustomerGrp5Text  on  _AdditionalCustomerGrp5Text.AdditionalCustomerGroup5 = $projection.AdditionalCustomerGroup5
                                                                                       and _AdditionalCustomerGrp5Text.Language                 = $session.system_language
  association [0..1] to I_OverallDeliveryStatusText    as _OverallDeliveryStatusText   on  _OverallDeliveryStatusText.OverallDeliveryStatus = $projection.OverallDeliveryStatus
                                                                                       and _OverallDeliveryStatusText.Language              = $session.system_language
  association [0..1] to I_Plant                        as _Plant                       on  _Plant.Plant = $projection.Plant
  association [0..1] to I_BR_NFDirectionText           as _BR_NFDirectionText          on  _BR_NFDirectionText.BR_NFDirection = $projection.BR_NFDirection
                                                                                       and _BR_NFDirectionText.Language       = $session.system_language
  association [0..1] to I_BR_NFModelText               as _BR_NFModelText              on  _BR_NFModelText.BR_NFModel = $projection.BR_NFModel
                                                                                       and _BR_NFModelText.Language   = $session.system_language


{
  key SalesDocument,
  key DeliveryDocument                                              as OutboundDelivery,
      SalesDocumentFirstItem,
      DeliveryDocumentFirstItem                                     as OutboundDeliveryFirstItem,

      /*Billing Document*/
      ltrim(_SDDeliveryFiltered.BillingDocument, '0')               as BillingDocument,
      BillingDocumentItem,
      _Billing.BillingDocumentDate,
      _Billing.AccountingPostingStatus,
      //      _AccountingPostingStatusText.AccountingPostingStatusDesc    as AccountingPostingStatusDesc,
      _Billing.BillingDocumentCategory,
      //      _BillingDocumentCategoryText.BillingDocumentCategoryName    as BillingDocumentCategoryName,
      _Billing.BillingDocumentType,
      //      _BillingDocumentTypeText.BillingDocumentTypeName            as BillingDocumentTypeName,

      //      /*Freight Order*/
      //      FreightOrder,
      //      FreightOrderComplete,
      //      cast(CreatedOn as  tzntstmpl)           as CreatedOn,
      //      cast(substring(
      //        cast(CreatedOn as abap.char( 28 )) , 1,8)
      //        as abap.dats)                                             as CreatedOnDat,
      //      /*Freight Order - Event*/
      //      _Frete.EventCode,

      /*Nota Fiscal*/
      BR_NotaFiscal,
      ltrim(BR_NotaFiscal,'0')                                      as NotaFiscal,
      _NFHeader.BR_NFeNumber                                        as BR_NFeNumber2,
      _NFHeader.BR_NFType                                           as BR_NFType,
      _NFHeader.BR_NFDocumentType                                   as BR_NFDocumentType,
      _NFHeader.CreationDate                                        as NFCreationDate,
      _NFHeader.CreationTime                                        as NFCreationTime,
      _NFHeader.BR_NFDirection                                      as BR_NFDirection,
      //      _BR_NFDirectionText.BR_NFDirectionDesc as BR_NFDirectionDesc,
      _NFHeader.BR_NFModel                                          as BR_NFModel,
      //      _BR_NFModelText.BR_NFModelDesc         as BR_NFModelDesc,

      /*Partner - Sales Order*/
      _VendorExt.Partner                                            as VendorExt,
      _VendorExt.PartnerName                                        as VendorExtName,
      _VendorInt.Partner                                            as VendorInt,
      _VendorInt.PartnerName                                        as VendorIntName,

      /*Delivery - Header*/
      _OutboundDelivery.kostk                                       as OverallPickingStatus,
      _OutboundDelivery.erdat                                       as DeliveryCreationDate,
      _OutboundDelivery.erzet                                       as DeliveryCreationTime,
      _OutboundDelivery.lifsk                                       as DeliveryBlockReason,
      //      _DeliveryBlockReasonText.DeliveryBlockReasonText            as DeliveryBlockReasonText,
      _OutboundDelivery.wbstk                                       as OverallGoodsMovementStatus,
      //      _OverallGoodsMovementStatusT.OverallGoodsMovementStatusDesc as OverallGoodsMovementStatusDesc,

      /*Delivery - Item*/
      _DeliveryItem.werks                                           as Plant,
      //      _Plant.PlantName           as PlantName,


      /*Sales Order - Header*/
      _SalesOrder.auart                                             as SalesOrderType,
      //      _SalesDocumentTypeText.SalesDocumentTypeName                as SalesOrderTypeName,
      _SalesOrder.kunnr                                             as SoldToParty,
      //      _SoldToParty.CustomerFullName                               as SoldToPartyName,
      _SalesOrder.vtweg                                             as DistributionChannel,
      //      _DistributionChannelText.DistributionChannelName            as DistributionChannelName,
      _SalesOrder.vkbur                                             as SalesOffice,
      //      _SalesOfficeText.SalesOfficeName                            as SalesOfficeName,
      _SalesOrder.vkgrp                                             as SalesGroup,
      //      _SalesGroupText.SalesGroupName                              as SalesGroupName,
      _SalesOrder.kvgr5                                             as AdditionalCustomerGroup5,
      //      _AdditionalCustomerGrp5Text.AdditionalCustomerGroup5Name    as AdditionalCustomerGroup5Name,
      _SalesOrder.lfstk                                             as OverallDeliveryStatus,
      //      _OverallDeliveryStatusText.OverallDeliveryStatusDesc        as OverallDeliveryStatusDesc,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _SalesOrder.netwr                                             as TotalNetAmount,
      _SalesOrder.waerk                                             as TransactionCurrency,
      _SalesOrder.bstdk                                             as CustomerPurchaseOrderDate,
      _SalesOrder.erdat                                             as CreationDate,
      cast( _SalesOrder.erzet as creation_time preserving type )    as CreationTime,
      cast(_SalesOrder.vdatu as reqd_delivery_date preserving type) as RequestedDeliveryDate,

      _vbkd.bzirk                                                   as SalesDistrict,
      //      _SalesDistrictText.SalesDistrictName,

      /*Sales Order - Item*/
      _SalesOrderItem.route                                         as Route,
      _SalesOrderItem.lprio                                         as DeliveryPriority,
      //      _Lprio.DeliveryPriorityDesc,

      /*Sales Order - Montante*/
      _Sales.ItemGrossWeightAvailable                               as ItemGrossWeightAvailable,
      _Sales.ItemGrossWeightTotal                                   as ItemGrossWeightTotal,
      fltp_to_dec( _Sales.ItemGrossWeightPerc as abap.dec(15,2) )   as ItemGrossWeightPerc,


      /*Log*/
      _Log._Log.Message                                             as Message,

      /*Calculados*/
      case when _Sales.ItemGrossWeightPerc < 25
           then 1    -- Vermelho
           when _Sales.ItemGrossWeightPerc > 75
           then 3    -- Verde
           else 2    -- Amarelo
           end                                                      as ItemGrossWeightPercCrit,

      case _NFHeader.BR_NFIsPrinted
      when 'X' then cast( 'X' as boole_d )
      else cast ( ' ' as boole_d )
      end                                                           as BR_NFIsPrinted,

      case _NFHeader.BR_NFeDocumentStatus
         when '1' then 'Autorizado'
         when '2' then 'Recusado'
         when '3' then 'Rejeitado'
         else '1ª tela'
      end                                                           as BR_NFeDocumentStatus,

      case _NFHeader.BR_NFeDocumentStatus
         when '1' then 3
         when '2' then 1
         else 2
      end                                                           as ColorBR_NFeDocumentStatus,

      case _Log._Log.Msgty
        when 'S' then 3
        when 'E' then 1
        when 'W' then 2
                 else 0 end                                         as Criticality,

      case _OutboundDelivery.kostk //OverallPickingStatus
      when 'A' then 'Não processado'
      when 'B' then 'Processado parcialmente'
      when 'C' then 'Processado completamente'
      else 'Irrelevante'
       end                                                          as PickingStatusText,

      case _OutboundDelivery.kostk //OverallPickingStatus
        when 'A' then 1
        when 'B' then 2
        when 'C' then 3
        else 0
        end                                                         as PickingStatusColor,

      ''                                                            as DeliveryBlockReasonNew,
      _NFDocumentType,
      _NFType

}
