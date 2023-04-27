@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Seleção Pedidos Coligadas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zi_sd_01_cockpit
  as select from ztsd_intercompan       as DBIntercompany
    inner join   ZI_SD_03_UNION_COCKPIT as _Cockpit on _Cockpit.Guid = DBIntercompany.guid

  composition [0..*] of ZI_SD_02_ITEM                as _Material
  composition [0..*] of ZI_SD_05_LOG                 as _Log

  association [0..1] to ZI_SD_VH_PROCESSO            as _Processo            on  _Processo.Processo = $projection.Processo
  association [0..1] to ZI_SD_VH_TPOPER              as _TipoOperacao        on  _TipoOperacao.tpOper = $projection.TipoOperacao
  association [0..1] to I_Plant                      as _WerksOrigem         on  _WerksOrigem.Plant = $projection.Werks_Origem
  association [0..1] to I_Plant                      as _WerksDestino        on  _WerksDestino.Plant = $projection.Werks_Destino
  association [0..1] to I_Plant                      as _WerksReceptor       on  _WerksReceptor.Plant = $projection.Werks_Receptor
  association [0..1] to I_StorageLocation            as _LgortOrigem         on  _LgortOrigem.Plant           = $projection.Werks_Origem
                                                                             and _LgortOrigem.StorageLocation = $projection.Lgort_Origem
  association [0..1] to I_StorageLocation            as _LgortDestino        on  _LgortDestino.Plant           = $projection.Werks_Destino
                                                                             and _LgortDestino.StorageLocation = $projection.Lgort_Destino
  association [0..1] to I_PurchaseOrgVH              as _PurchOrg            on  _PurchOrg.ResponsiblePurchaseOrg = $projection.ekorg
  association [0..1] to I_PurchasingGroup            as _PurchGrp            on  _PurchGrp.PurchasingGroup = $projection.ekgrp
  association [0..1] to ZI_MM_VH_MOTIVO_BLOQ_REMESSA as _Bloqueio            on  _Bloqueio.DeliveryBlockReason = $projection.DelivBlockReason
  association [0..1] to t173t                        as _TipoExped           on  _TipoExped.spras = $session.system_language
                                                                             and _TipoExped.vsart = $projection.Tpexp
  association [0..1] to ZI_CA_VH_VSBED               as _CondExped           on  _CondExped.CondicaoExpedicao = $projection.CondExp
  association [0..1] to lfa1                         as _AgenteFrete         on  _AgenteFrete.lifnr = $projection.Agfrete
  association [0..1] to ZI_CA_VH_KUNNR               as _Motorista           on  _Motorista.Kunnr = $projection.Motora
  association [0..1] to ZI_SD_VH_FRACIONADO          as _Fracionado          on  _Fracionado.Fracionado = $projection.Fracionado
  association [0..1] to I_DeliveryDocument           as _Delivery            on  _Delivery.DeliveryDocument = $projection.Remessa
  association [0..1] to I_DeliveryBlockReasonText    as _DeliveryBlockReason on  _DeliveryBlockReason.DeliveryBlockReason = $projection.deliveryblockreason
                                                                             and _DeliveryBlockReason.Language            = $session.system_language
  association [0..1] to I_SalesOrder                 as _SalesOrder          on  _SalesOrder.SalesOrder = $projection.SalesOrder
  association [0..1] to I_PurchaseOrder              as _PurchaseOrder       on  _PurchaseOrder.PurchaseOrder = $projection.PurchaseOrder
  //  association [0..1] to I_BR_NFDocument              as _NFDoc               on  _NFDoc.BR_NotaFiscal = $projection.br_notafiscal
  //  association [0..1] to I_BR_NFDocument              as _NFDocEntrada        on  _NFDocEntrada.BR_NotaFiscal = $projection.nfentrada
  //  association [0..1] to I_BR_PurchaseHistory           as _MaterialDoc         on  _MaterialDoc.PurchaseOrder                = $projection.PurchaseOrder
  //                                                                               and _MaterialDoc.PurchaseOrderItem            = '00010'
  //                                                                               and _MaterialDoc.PurchaseOrderTransactionType = '6'
  //  association [0..1] to I_BR_NFeActive               as _NFeActive           on  _NFeActive.BR_NotaFiscal = _Cockpit.br_notafiscal
  //  association [0..1] to I_BR_NFeDocumentStatusText     as _DocStatusText       on  _DocStatusText.BR_NFeDocumentStatus = $projection.br_nfedocumentstatus
  //                                                                               and _DocStatusText.Language             = $session.system_language
  association [0..1] to I_MatlUsageIndicatorText     as _Utilizacao          on  _Utilizacao.MatlUsageIndicator = _Cockpit.abrvw
                                                                             and _Utilizacao.Language           = $session.system_language
  association [0..1] to ZI_CA_VH_MDFRETE             as _TpFreteText         on  _TpFreteText.mdFrete = $projection.Tpfrete
  association [0..1] to ZI_SD_VH_STATUS_PICKING      as _StatusPickingText   on  _StatusPickingText.OverallSDProcessStatus = $projection.overallpickingstatus
  //  association [0..1] to I_OverallSDProcessStatus       as  _StatusPickingText   on  _StatusPickingText.OverallSDProcessStatus = $projection.overallpickingconfstatus
  association [0..1] to I_UserContactCard            as _CreatedByUser       on  _CreatedByUser.ContactCardID = $projection.CreatedBy
  association [0..1] to I_UserContactCard            as _ChangedByUser       on  _ChangedByUser.ContactCardID = $projection.LastChangedBy
{
  key _Cockpit.Guid,
      _Cockpit.SalesOrder,
      _Cockpit.PurchaseOrder,
      _Cockpit.br_notafiscal,
      _Cockpit.BR_NFeNumber,
      _Cockpit.Werks_Origem,
      _Cockpit.Werks_Destino,
      _Cockpit.Lgort_Origem,
      _Cockpit.Lgort_Destino,
      _Cockpit.Werks_Receptor,
      case when _Cockpit.Processo = '1'
           then _PurchaseOrder.CreationDate
           else _SalesOrder.CreationDate
      end                                            as Creationdate,
      3                                              as DocPrinCritic,
      _Cockpit.Remessa,
      _Cockpit.Ztraid,
      _Cockpit.Ztrai1,
      _Cockpit.Ztrai2,
      _Cockpit.Ztrai3,
      _Delivery.DeliveryBlockReason,
      _Delivery.OverallPickingStatus,
      _Delivery.OverallGoodsMovementStatus,
      _Cockpit.Docfat,
      _Cockpit.PurchaseOrder2                        as Correspncexternalreference,
      _Cockpit.SalesOrder2,
      _Cockpit.TipoOperacao,
      _Cockpit.br_nfedocumentstatus,
      _Cockpit.BR_NFeDocumentStatusDesc,
      _Cockpit.Tpfrete,
      _Cockpit.Agfrete,
      _Cockpit.Motora,
      _Cockpit.Tpexp,
      _Cockpit.CondExp,
      _Cockpit.Txtnf,
      _Cockpit.Txtgeral,
      _Cockpit.FreightOrder                          as Docnuv,
      //      concat(_NFeActive.Region,
      //      concat(_NFeActive.BR_NFeIssueYear,
      //      concat(_NFeActive.BR_NFeIssueMonth,
      //      concat(_NFeActive.BR_NFeAccessKeyCNPJOrCPF,
      //      concat(_NFeActive.BR_NFeModel,
      //      concat(_NFeActive.BR_NFeSeries,
      //      concat(_NFeActive.BR_NFeNumber,
      //      concat(_NFeActive.BR_NFeRandomNumber, _NFeActive.BR_NFeCheckDigit) ) ) ) ) ) ) ) as ChaveAcesso,
      _Cockpit.ChaveAcesso,
      _Cockpit.Processo,
      _Cockpit.Fracionado,
      _Cockpit.IdSaga,
      _Cockpit.ekorg,
      _Cockpit.ekgrp,
      _Cockpit.abrvw,
      //      _MaterialDoc.BR_NFSourceDocumentNumber                                           as DocMaterial,
      _Cockpit.nfentrada,
      _Cockpit.BR_NFeNumberEntrada,
      _Cockpit.RemessaOrigem,
      @Semantics.user.createdBy: true
      _Cockpit.CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      cast(_Cockpit.CreatedAt as timestamp)          as CreatedAt,
      tstmp_to_dats( cast(_Cockpit.CreatedAt as timestamp),
                     abap_system_timezone( $session.client,'NULL' ),
                     $session.client, 'NULL' )       as CreatedAtDate,
      @Semantics.user.lastChangedBy: true
      _Cockpit.LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      cast(_Cockpit.LastChangedAt as timestamp)      as LastChangedAt,
      tstmp_to_dats( cast(_Cockpit.LastChangedAt as timestamp),
                     abap_system_timezone( $session.client,'NULL' ),
                     $session.client, 'NULL' )       as LastChangedAtDate,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      cast(_Cockpit.LocalLastChangedAt as timestamp) as LocalLastChangedAt,

      case when _Cockpit.SalesOrder is initial
             or _Cockpit.SalesOrder is null
           then 'X'
           else ' '
      end                                            as HiddenSO,

      case when _Cockpit.PurchaseOrder is initial
             or _Cockpit.PurchaseOrder is null
           then 'X'
           else ' '
      end                                            as HiddenPO,

      case when _Cockpit.Remessa is initial
             or _Cockpit.Remessa is null
           then 'X'
           else ' '
      end                                            as HiddenRemessa,

      case when _Cockpit.Docfat is initial
             or _Cockpit.Docfat is null
           then 'X'
           else ' '
      end                                            as HiddenFatura,

      case when _Cockpit.br_notafiscal is initial
             or _Cockpit.br_notafiscal is null
           then 'X'
           else ' '
      end                                            as HiddenNFOut,

      case when _Cockpit.FreightOrder is initial
             or _Cockpit.FreightOrder is null
           then 'X'
           else ' '
      end                                            as HiddenOF,

      case when _Cockpit.nfentrada is initial
             or _Cockpit.nfentrada is null
           then 'X'
           else ' '
      end                                            as HiddenNFInb,

      cast('' as lifsp)                              as DelivBlockReason,

      _Processo,
      _TipoOperacao,
      _WerksOrigem,
      _LgortOrigem,
      _WerksDestino,
      _LgortDestino,
      _WerksReceptor,
      //      _NFDoc,
      //      _NFDocEntrada,
      //      _NFItem,
      _PurchOrg,
      _PurchGrp,
      _Bloqueio,
      _DeliveryBlockReason,
      _TipoExped,
      _CondExped,
      _AgenteFrete,
      _Motorista,
      _Fracionado,
      _Material,
      _Utilizacao,
      //      _MaterialDoc,
      //      _DocStatusText,
      _TpFreteText,
      _StatusPickingText,
      _CreatedByUser,
      _ChangedByUser,
      _Log

}
