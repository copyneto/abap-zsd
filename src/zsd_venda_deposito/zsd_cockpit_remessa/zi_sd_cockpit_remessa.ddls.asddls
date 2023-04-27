@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit gerenciamento de remessas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_COCKPIT_REMESSA

  as select from           ZI_SD_REMESSA_INFO_DOCS                           as _Header

    left outer to one join I_SalesOrderItem                                  as _Item          on  _Item.SalesOrder     = _Header.SalesDocument
                                                                                               and _Item.SalesOrderItem = _Header.SalesDocumentFirstItem


    inner join             I_SalesDocumentBasic                              as _SalesDocument on _SalesDocument.SalesDocument = _Header.SalesDocument

    inner join             ZI_SD_CKPT_FAT_PARAMETROS( p_chave1 : 'ADM_FATURAMENTO',
                                                      p_chave2 : 'TIPOS_OV') as _Param         on  _Param.parametro = _SalesDocument.SalesDocumentType
                                                                                               and _Param.chave3    = ''

    left outer join        I_SalesOrder                                      as _SalesOrder    on _SalesOrder.SalesOrder = _Header.SalesDocument

    left outer join        ZI_SD_CKPT_AGEN_REMESSA_HEADER                    as _Remessa       on  _Remessa.SalesOrder = _Header.SalesDocument
                                                                                               and _Remessa.Document   = _Header.DeliveryDocument
  //    left outer join ZI_SD_CKPT_AGEN_FATURA                            as _Fatura        on _Fatura.SalesOrder = _Header.DeliveryDocument
  //    left outer join        ZI_SD_REMESSA_INFO_FATURA                         as _Fatura        on _Fatura.SalesOrder = _Header.DeliveryDocument

    left outer to one join I_BR_NFDocument                                   as _Fatura2       on _Header.BR_NotaFiscal = _Fatura2.BR_NotaFiscal
  //    left outer to one join ZI_SD_REMESSA_FRETE_EVENT2                        as _Frete         on _Header.FreightOrder = ltrim(
  //      _Frete.OrdemFrete, '0'
  //    )

  composition [0..*] of ZI_SD_COCKPIT_REMESSA_LOG      as _CockpitLog


  association [0..1] to ZI_SD_REMESSA_FRETE_EVENT3     as _Frete             on  _Frete.OrdemFrete = $projection.FreightOrderComplete

  association [0..1] to I_SalesDistrictText            as _SalesDistrictText on  _SalesDistrictText.SalesDistrict = $projection.SalesDistrict
                                                                             and _SalesDistrictText.Language      = $session.system_language


  association [0..1] to I_DeliveryDocumentItem         as _DeliveryItem      on  _DeliveryItem.DeliveryDocument     = $projection.OutboundDelivery
                                                                             and _DeliveryItem.DeliveryDocumentItem = $projection.OutboundDeliveryFirstItem

  association [0..1] to ZI_SD_REMESSA_INFO_ORDEM_VENDA as _Sales             on  _Sales.SalesDocument = $projection.SalesDocument

  association [0..1] to I_BillingDocument              as _Billing           on  _Billing.BillingDocument = $projection.BillingDocument2

  //  association [0..1] to I_BR_NFDocument                as _NF                on  _NF.BR_NotaFiscal = $projection.BR_NotaFiscal2

  association [0..1] to ZI_CA_VH_NFTYPE                as _NFType            on  _NFType.BR_NFType = $projection.BR_NFType

  association [0..1] to ZI_CA_VH_DOCTYP_NF             as _NFDocumentType    on  _NFDocumentType.BR_NFDocumentType = $projection.BR_NFDocumentType

  association [0..1] to ZI_SD_REMESSA_INFO_PARC_INT    as _VendorInt         on  _VendorInt.SalesOrder = $projection.SalesDocument

  association [0..1] to ZI_SD_REMESSA_INFO_PARC_EXT    as _VendorExt         on  _VendorExt.SalesOrder = $projection.SalesDocument

  association [0..1] to ZI_VH_SD_LPRIO                 as _Lprio             on  _Lprio.DeliveryPriority = $projection.DeliveryPriority

  association [0..1] to ZI_SD_REMESSA_LOG_ULTIMO       as _Log               on  _Log.OutboundDelivery = $projection.OutboundDelivery

  association [1..1] to I_OutboundDelivery             as _OutboundDelivery  on  _OutboundDelivery.OutboundDelivery = $projection.OutboundDelivery
{
  key _Header.SalesDocument                                                          as SalesDocument,
  key _Header.DeliveryDocument                                                       as OutboundDelivery,
      _VendorInt.Partner                                                             as VendorInt,
      _VendorInt.PartnerName                                                         as VendorIntName,
      _VendorExt.Partner                                                             as VendorExt,
      _VendorExt.PartnerName                                                         as VendorExtName,
      _Header.SalesDocumentFirstItem                                                 as SalesDocumentFirstItem,
      _Header.DeliveryDocumentFirstItem                                              as OutboundDeliveryFirstItem,
      _SalesDocument.SalesDocumentType                                               as SalesOrderType,
      _SalesDocument._SalesDocumentType._Text
      [1:Language = $session.system_language].SalesDocumentTypeName                  as SalesOrderTypeName,
      _DeliveryItem._ReferenceSDDocument.RequestedDeliveryDate                       as RequestedDeliveryDate,
      _DeliveryItem._ReferenceSDDocument.SoldToParty                                 as SoldToParty,
      _DeliveryItem._ReferenceSDDocument._SoldToParty.CustomerFullName               as SoldToPartyName,
      _DeliveryItem._DeliveryDocument.DeliveryBlockReason                            as DeliveryBlockReason,
      _DeliveryItem._DeliveryDocument._DeliveryBlockReason._Text
      [1:Language = $session.system_language].DeliveryBlockReasonText                as DeliveryBlockReasonText,
      _DeliveryItem._ReferenceSDDocument.CreationDate                                as SalesCreationDate,
      _DeliveryItem._ReferenceSDDocument.CreationTime                                as SalesCreationTime,
      _DeliveryItem.Plant                                                            as Plant,
      _DeliveryItem._Plant.PlantName                                                 as PlantName,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _DeliveryItem._ReferenceSDDocument.TotalNetAmount                              as TotalNetAmount,
      _DeliveryItem._ReferenceSDDocument.TransactionCurrency                         as TransactionCurrency,
      _Header.FreightOrder                                                           as FreightOrder,
      _Header.FreightOrderComplete                                                   as FreightOrderComplete,

      cast(_Header.CreatedOn as  tzntstmpl)                                          as CreatedOn,
      cast(substring(cast(_Header.CreatedOn as abap.char( 28 )) , 1,8) as abap.dats) as CreatedOnDat,
      _DeliveryItem._DeliveryDocument.OverallGoodsMovementStatus                     as OverallGoodsMovementStatus,
      _DeliveryItem._DeliveryDocument._OverallGoodsMovementStatus._Text
      [1:Language = $session.system_language].OverallGoodsMovementStatusDesc         as OverallGoodsMovementStatusDesc,
      ltrim(_Header.BillingDocument, '0')                                            as BillingDocument,
      _Header.BillingDocument                                                        as BillingDocument2,
      //      _Fatura.Document                                                               as BillingDocument,
      _Billing.AccountingPostingStatus                                               as AccountingPostingStatus,
      _Billing._AccountingPostingStatus._Text
      [1:Language = $session.system_language].AccountingPostingStatusDesc            as AccountingPostingStatusDesc,
      _Billing.BillingDocumentDate                                                   as BillingDocumentDate,

      _Billing.BillingDocumentCategory                                               as BillingDocumentCategory,
      _Billing._BillingDocumentCategory._Text
      [1:Language = $session.system_language].BillingDocumentCategoryName            as BillingDocumentCategoryName,
      _Billing.BillingDocumentType                                                   as BillingDocumentType,
      _Billing._BillingDocumentType._Text
      [1:Language = $session.system_language].BillingDocumentTypeName                as BillingDocumentTypeName,

      _DeliveryItem._ReferenceSDDocument.SalesDocumentType                           as SalesDocumentType,
      _DeliveryItem._ReferenceSDDocument._SalesDocumentType._Text
      [1:Language = $session.system_language].SalesDocumentTypeName                  as SalesDocumentTypeName,
      _DeliveryItem._ReferenceSDDocument.DistributionChannel                         as DistributionChannel,
      _DeliveryItem._ReferenceSDDocument._DistributionChannel._Text
      [1:Language = $session.system_language].DistributionChannelName                as DistributionChannelName,
      _DeliveryItem._ReferenceSDDocument.SalesOffice                                 as SalesOffice,
      _DeliveryItem._ReferenceSDDocument._SalesOffice._Text
      [1:Language = $session.system_language].SalesOfficeName                        as SalesOfficeName,
      _DeliveryItem._ReferenceSDDocument.SalesGroup                                  as SalesGroup,
      _DeliveryItem._ReferenceSDDocument._SalesGroup._Text
      [1:Language = $session.system_language].SalesGroupName                         as SalesGroupName,
      _DeliveryItem._ReferenceSDDocument.CustomerPurchaseOrderDate                   as CustomerPurchaseOrderDate,
      _DeliveryItem._DeliveryDocument.CreationDate                                   as DeliveryCreationDate,
      _DeliveryItem._DeliveryDocument.CreationTime                                   as DeliveryCreationTime,

      _Sales.ItemGrossWeightAvailable                                                as ItemGrossWeightAvailable,
      _Sales.ItemGrossWeightTotal                                                    as ItemGrossWeightTotal,
      fltp_to_dec( _Sales.ItemGrossWeightPerc as abap.dec(15,2) )                    as ItemGrossWeightPerc,

      case when _Sales.ItemGrossWeightPerc < 25
           then 1    -- Vermelho
           when _Sales.ItemGrossWeightPerc > 75
           then 3    -- Verde
           else 2    -- Amarelo
           end                                                                       as ItemGrossWeightPercCrit,

      _DeliveryItem._ReferenceSDDocument.AdditionalCustomerGroup5                    as AdditionalCustomerGroup5,
      _DeliveryItem._ReferenceSDDocument._AdditionalCustomerGroup5._Text
      [1:Language = $session.system_language].AdditionalCustomerGroup5Name           as AdditionalCustomerGroup5Name,
      _DeliveryItem._ReferenceSDDocument.OverallDeliveryStatus                       as OverallDeliveryStatus,
      _DeliveryItem._ReferenceSDDocument._OverallDeliveryStatus._Text
      [1:Language = $session.system_language].OverallDeliveryStatusDesc              as OverallDeliveryStatusDesc,

      //      _Header.BR_NotaFiscal                                                  as BR_NotaFiscal,
      _Header.BR_NFeNumber                                                           as BR_NotaFiscal2,
      _Header.BR_NFeNumber2                                                          as BR_NotaFiscal,
      //      _Fatura.NotaFiscal                                                             as BR_NotaFiscal,
      ltrim(_Header.BR_NotaFiscal,'0')                                               as NotaFiscal,
      //      _Fatura.DocNum                                                                 as NotaFiscal,

      //      _NF.BR_NFType                                                                  as BR_NFType,
      //      _NF.BR_NFDocumentType                                                          as BR_NFDocumentType,
      //      _NF.BR_NFDirection                                                             as BR_NFDirection,
      //      _NF._BR_NFDirection._Text
      //      [1:Language = $session.system_language].BR_NFDirectionDesc                     as BR_NFDirectionDesc,
      //      _NF.BR_NFModel                                                                 as BR_NFModel,
      //      _NF._BR_NFModel._Text
      //      [1:Language = $session.system_language].BR_NFModelDesc                         as BR_NFModelDesc,
      //      _NF.CreationDate                                                               as NFCreationDate,
      //      _NF.CreationTime                                                               as NFCreationTime,
      _Fatura2.BR_NFType                                                             as BR_NFType,
      _Fatura2.BR_NFDocumentType                                                     as BR_NFDocumentType,
      _Fatura2.BR_NFDirection                                                        as BR_NFDirection,
      _Fatura2._BR_NFDirection._Text
      [1:Language = $session.system_language].BR_NFDirectionDesc                     as BR_NFDirectionDesc,
      _Fatura2.BR_NFModel                                                            as BR_NFModel,
      _Fatura2._BR_NFModel._Text
      [1:Language = $session.system_language].BR_NFModelDesc                         as BR_NFModelDesc,
      _Fatura2.CreationDate                                                          as NFCreationDate,
      _Fatura2.CreationTime                                                          as NFCreationTime,

      _SalesOrder.SalesDistrict,
      _SalesDistrictText.SalesDistrictName,

      /* Abstract */
      ''                                                                             as DeliveryBlockReasonNew,
      _NFType,
      _NFDocumentType,
      _Item.DeliveryPriority,
      _Lprio.DeliveryPriorityDesc,
      _Item.Route,
      case _Fatura2.BR_NFIsPrinted
      when 'X' then cast( 'X' as boole_d )
      else cast ( ' ' as boole_d )
      end                                                                            as BR_NFIsPrinted,


      case _Fatura2.BR_NFeDocumentStatus
         when '1' then 'Autorizado'
         when '2' then 'Recusado'
         when '3' then 'Rejeitado'
         else '1ª tela'
      end                                                                            as BR_NFeDocumentStatus,

      case _Fatura2.BR_NFeDocumentStatus
         when '1' then 3
         when '2' then 1
         else 2
      end                                                                            as ColorBR_NFeDocumentStatus,
      _Frete.EventCode,

      case _Log._Log.Msgty
        when 'S' then 3
        when 'E' then 1
        when 'W' then 2
                 else 0 end                                                          as Criticality,

      _OutboundDelivery.OverallPickingStatus,

      case _OutboundDelivery.OverallPickingStatus
      when 'A' then 'Não processado'
      when 'B' then 'Processado parcialmente'
      when 'C' then 'Processado completamente'
      else 'Irrelevante'
       end                                                                           as PickingStatusText,

      case _OutboundDelivery.OverallPickingStatus
        when 'A' then 1
        when 'B' then 2
        when 'C' then 3
        else 0
        end                                                                          as PickingStatusColor,

      _Log._Log.Message                                                              as Message,

      /* compositions*/
      _CockpitLog

}
