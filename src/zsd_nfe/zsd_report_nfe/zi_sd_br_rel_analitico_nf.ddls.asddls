@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Relatório Analítico de Notas Fiscais'
@VDM.viewType: #COMPOSITE

define view entity ZI_SD_BR_REL_ANALITICO_NF
  as select from    I_BR_NFItem_C                  as NfItem

    left outer join I_BR_NFItemDocumentFlowFirst_C as _NFDocumentFlow on  _NFDocumentFlow.BR_NotaFiscal     = NfItem.BR_NotaFiscal
                                                                      and _NFDocumentFlow.BR_NotaFiscalItem = NfItem.BR_NotaFiscalItem

    left outer join I_BR_NFDocument                as _NFDocument     on _NFDocument.BR_NotaFiscal = NfItem.BR_NotaFiscal

  association [0..1] to I_BR_BusinessPlace_C       as _BusinessPlace         on  _BusinessPlace.Branch      = $projection.BusinessPlace
                                                                             and _BusinessPlace.CompanyCode = _NFDocument.CompanyCode

  association [0..1] to I_BillingDocument          as _BillingDocument       on  _BillingDocument.BillingDocument = _NFDocumentFlow.ReferenceDocument

  association [0..1] to I_SalesOrder               as _SalesOrder            on  _SalesOrder.SalesOrder = _NFDocumentFlow.OriginReferenceDocument

  association [1..1] to I_BR_NFItem                as _NFItem                on  _NFItem.BR_NotaFiscal     = $projection.BR_NotaFiscal
                                                                             and _NFItem.BR_NotaFiscalItem = $projection.BR_NotaFiscalItem

  association [0..1] to I_BR_NFItemTaxByItem_C     as _ICMSSubTrib           on  _ICMSSubTrib.BR_NotaFiscal                  = $projection.BR_NotaFiscal
                                                                             and _ICMSSubTrib.BR_NotaFiscalItem              = $projection.BR_NotaFiscalItem
                                                                             and _ICMSSubTrib.TaxGroup                       = 'ICST'
                                                                             and _ICMSSubTrib.BR_ICMSPartilhaSubdivisionCode = ''

  association [0..1] to I_BR_NFItemTaxByItem_C     as _ICMS_EC87_Destination on  _ICMS_EC87_Destination.BR_NotaFiscal                  = $projection.BR_NotaFiscal
                                                                             and _ICMS_EC87_Destination.BR_NotaFiscalItem              = $projection.BR_NotaFiscalItem
                                                                             and _ICMS_EC87_Destination.TaxGroup                       = 'ICMS'
                                                                             and _ICMS_EC87_Destination.BR_ICMSPartilhaSubdivisionCode = '001'

  association [0..1] to I_BR_NFItemTaxByItem_C     as _ICMS_EC87_Origin      on  _ICMS_EC87_Origin.BR_NotaFiscal                  = $projection.BR_NotaFiscal
                                                                             and _ICMS_EC87_Origin.BR_NotaFiscalItem              = $projection.BR_NotaFiscalItem
                                                                             and _ICMS_EC87_Origin.TaxGroup                       = 'ICMS'
                                                                             and _ICMS_EC87_Origin.BR_ICMSPartilhaSubdivisionCode = '002'

  association [0..1] to I_BR_NFItemTaxByItem_C     as _ICMS_FCP              on  _ICMS_FCP.BR_NotaFiscal                    = $projection.BR_NotaFiscal
                                                                             and _ICMS_FCP.BR_NotaFiscalItem                = $projection.BR_NotaFiscalItem
                                                                             and _ICMS_FCP.TaxGroup                         = 'ICMS'
                                                                             and (
                                                                                _ICMS_FCP.BR_ICMSPartilhaSubdivisionCode    = '003'
                                                                                or _ICMS_FCP.BR_ICMSPartilhaSubdivisionCode = '004'
                                                                              )

  association [0..1] to ZI_CA_VH_DIRECAO_NF        as _NFDirection           on  _NFDirection.BR_NFDirection = $projection.BR_NFDirection

  association [0..1] to I_BR_NFeDocumentStatusText as _NFeDocumentStatusText on  _NFeDocumentStatusText.BR_NFeDocumentStatus = $projection.BR_NFeDocumentStatus
                                                                             and _NFeDocumentStatusText.Language             = $session.system_language


{

  key    NfItem.BR_NotaFiscal,

  key    NfItem.BR_NotaFiscalItem,

         _NFDocument.CompanyCode,

         _NFDocument.CompanyCodeName,

         _NFDocument.BusinessPlace,

         _BusinessPlace.BusinessPlaceName,

         //_CompanyCodeSearchHelp.CompanyCodeName,
         NfItem.Plant,

         _NFDocument.CreatedByUser,

         _NFDocument.LastChangedByUser                         as CancellationChangedByUser,

         case _NFDocument.BR_NFDirection
           when '2' then _NFDocument.BR_NFPartner
           else _NFDocument.BusinessPlace
         end                                                   as ZBR_NFPartner,

         case _NFDocument.BR_NFDirection
           when '2' then _NFDocument.BR_NFPartnerName1
           else _BusinessPlace.BusinessPlaceName
         end                                                   as BR_NFReceiverNameFrmtdDesc,

         _NFDocument.BR_NFeNumber,

         _NFItem.BR_CFOPCode,

         _NFDocument.BR_NFIssueDate,

         _NFDocument.BR_NFPostingDate,

         _NFDocument.CreationTime,

         _NFDocument.BR_NFCancellationDate,

         _NFDocument.LastChangeTime,

         NfItem.Material,

         NfItem.MaterialName,

         cast(NfItem.QuantityInBaseUnit as abap.dec( 15, 3 ) ) as QuantityInBaseUnit,

         NfItem.BaseUnit,

         //         @Semantics.quantity.unitOfMeasure: 'BaseUnit'
         //         unit_conversion( quantity => NfItem.QuantityInBaseUnit,
         //                          source_unit => NfItem.BaseUnit,
         //                          target_unit => cast( 'KG' as abap.unit ),
         //                          error_handling => 'SET_TO_NULL' )    as ConvF1,

         _NFDocument.SalesDocumentCurrency, //não exibir

         //@Semantics.amount.currencyCode:'SalesDocumentCurrency'
         cast(NfItem.NetValueAmount as logbr_invoicenetamount) as NetValueAmount,

         //Tax Amount
         NfItem.BR_ICMSBaseAmount,

         NfItem.BR_ICMSTaxAmount,

         NfItem.ZBR_IPIBaseAmount,

         NfItem.BR_IPITaxAmount,

         _ICMSSubTrib.BR_NFItemBaseAmount                      as BR_ICMSSTBaseAmount,

         _ICMSSubTrib.BR_NFItemTaxAmount                       as BR_ICMSSTAmount,

         _ICMS_EC87_Destination.BR_NFItemTaxAmount             as BR_ICMSDestinationTaxAmount,

         _ICMS_EC87_Origin.BR_NFItemTaxAmount                  as BR_ICMSOriginTaxAmount,

         _ICMS_FCP.BR_NFItemTaxAmount                          as BR_FCPOnICMSTaxAmount,

         _BillingDocument.DistributionChannel,

         _SalesOrder.SDDocumentReason,

         _BillingDocument.Division,

         _NFDocument.BR_NFPartnerType,

         _NFDocument.BR_NFIsCanceled,

         _NFDocument.BR_NFType,

         _BillingDocument.BillingDocumentType,

         _NFDocument.BR_NFeDocumentStatus,

         _NFDocument.BR_NFIsCreatedManually,

         _NFDocument.BR_NFDirection,

         _NFDirection.BR_NFDirectionDesc,

         _NFeDocumentStatusText.BR_NFeDocumentStatusDesc

}
