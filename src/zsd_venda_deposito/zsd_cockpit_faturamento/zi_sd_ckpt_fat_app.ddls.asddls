@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cockpit Faturamento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define root view entity ZI_SD_CKPT_FAT_APP
  as select from    I_SalesOrder                                      as _SalesOrder
    inner join      ZI_SD_CKPT_FAT_PARAMETROS( p_chave1 : 'ADM_FATURAMENTO',
                                               p_chave2 : 'TIPOS_OV') as _Param              on _Param.parametro = _SalesOrder.SalesOrderType


    inner join      ZI_SD_CKPT_FAT_AGRUPA_ITEM                        as _Item2              on _SalesOrder.SalesOrder = _Item2.SalesOrder

    inner join      I_SalesOrderItem                                  as _Item               on  _Item.SalesOrder     = _Item2.SalesOrder
                                                                                             and _Item.SalesOrderItem = _Item2.SalesOrderItem


    left outer join ZI_SD_CKPT_FAT_AGENDAMENTO                        as _TipoAgendaCliente  on  _TipoAgendaCliente.kunnr = _SalesOrder.SoldToParty
                                                                                             and _TipoAgendaCliente.vkorg = _SalesOrder.SalesOrganization
                                                                                             and _TipoAgendaCliente.vtweg = _SalesOrder.DistributionChannel
                                                                                             and _TipoAgendaCliente.spart = _SalesOrder.OrganizationDivision

    left outer join ZI_SD_CKPT_FAT_LIBCOMERCIAL                       as _LiberacaoComercial on _LiberacaoComercial.SalesOrder = _SalesOrder.SalesOrder
    left outer join ZI_SD_CENTRO_FAT_DF                               as _Centro             on _Centro.CentroFaturamento = _Item.Plant
    left outer join ZI_SD_PEDIDO_AUX                                  as _Aux                on _Aux.SalesOrder = _SalesOrder.SalesOrder

    left outer join ZI_SD_CKPT_AGEND_REMESSA_DT                       as _Agenda             on  _Agenda.ordem = _Item2.SalesOrder
                                                                                             and _Agenda.item  = _Item2.SalesOrderItem

    left outer join ztsd_agendamento                                  as _DataAgenda         on  _DataAgenda.ordem         = _Agenda.ordem
                                                                                             and _DataAgenda.item          = _Agenda.item
                                                                                             and _DataAgenda.data_registro = _Agenda.DataRegistro
                                                                                             and _DataAgenda.hora_registro = _Agenda.HoraRegistro

  association        to ZI_SD_CKPT_FAT_PESOBRUTO      as _pesobruto                 on  _pesobruto.SalesOrder = $projection.SalesOrder

  association        to I_OverallSDProcessStatusText  as _SalesOrderStatus          on  _SalesOrderStatus.OverallSDProcessStatus = _SalesOrder.OverallSDProcessStatus
                                                                                    and _SalesOrderStatus.Language               = $session.system_language

  association        to I_OverallDeliveryStatusText   as _OverallDeliveryStatus     on  _OverallDeliveryStatus.OverallDeliveryStatus = _SalesOrder.OverallDeliveryStatus
                                                                                    and _OverallDeliveryStatus.Language              = $session.system_language
  //  association to ZI_SD_CKPT_FAT_VENDEDOR    as _Vendedor   on  _Vendedor.SalesOrder = $projection.SalesOrder

  association [0..1] to ZI_SD_REMESSA_INFO_PARC_INT   as _VendedorInt               on  _VendedorInt.SalesOrder = $projection.SalesOrder

  association [0..1] to ZI_SD_REMESSA_INFO_PARC_EXT   as _VendedorExt               on  _VendedorExt.SalesOrder = $projection.SalesOrder

  association        to ZI_SD_CKPT_FAT_PARTNER        as _Partner                   on  _Partner.SDDocument = $projection.SalesOrder
  association        to ZI_SD_CKPT_FAT_DATAFAT        as _datafat                   on  _datafat.SalesOrder = $projection.SalesOrder

  //////  association        to ZI_SD_CKPT_AGEN_ITEM_APP     as _Agendamento               on  _Agendamento.SalesOrder     = $projection.SalesOrder
  //////                                                                                   and _Agendamento.SalesOrderItem = _Item.SalesOrderItem

  //  association [0..1] to ZI_SD_CKPT_FAT_AGENDAMENTO  as _agend                     on  _agend.SalesOrder = $projection.SalesOrder
  //                                                                                  and _agend.Customer is not initial

  association        to ZI_SD_CKPT_FAT_COMEX          as _Comex                     on  _Comex.SalesOrder = $projection.SalesOrder

  association        to ZI_SD_VERIF_DISP_MATERIAL     as _Mat                       on  _Mat.SalesOrder = $projection.SalesOrder

  association        to ZI_SD_CICLO_PO                as _CicloPo001                on  _CicloPo001.ordem_venda = _SalesOrder.SalesOrder
                                                                                    and _CicloPo001.medicao     = '001'
  association        to ZI_SD_CICLO_PO                as _CicloPo002                on  _CicloPo002.ordem_venda = _SalesOrder.SalesOrder
                                                                                    and _CicloPo002.medicao     = '002'
  association        to ZI_SD_CICLO_PO                as _CicloPo003                on  _CicloPo003.ordem_venda = _SalesOrder.SalesOrder
                                                                                    and _CicloPo003.medicao     = '003'
  association        to ZI_SD_CICLO_PO                as _CicloPo004                on  _CicloPo004.ordem_venda = _SalesOrder.SalesOrder
                                                                                    and _CicloPo004.medicao     = '004'
  association        to ZI_SD_CICLO_PO                as _CicloPo005                on  _CicloPo005.ordem_venda = _SalesOrder.SalesOrder
                                                                                    and _CicloPo005.medicao     = '005'
  association        to ZI_SD_CICLO_PO                as _CicloPo006                on  _CicloPo006.ordem_venda = _SalesOrder.SalesOrder
                                                                                    and _CicloPo006.medicao     = '006'
  association        to ZI_SD_CICLO_PO                as _CicloPo007                on  _CicloPo007.ordem_venda = _SalesOrder.SalesOrder
                                                                                    and _CicloPo007.medicao     = '007'
  association        to ZI_SD_CICLO_PO                as _CicloPo008                on  _CicloPo008.ordem_venda = _SalesOrder.SalesOrder
                                                                                    and _CicloPo008.medicao     = '008'
  association        to ZI_SD_CICLO_PO                as _CicloPo009                on  _CicloPo009.ordem_venda = _SalesOrder.SalesOrder
                                                                                    and _CicloPo009.medicao     = '009'
  association        to ZI_SD_CICLO_PO                as _CicloPo010                on  _CicloPo010.ordem_venda = _SalesOrder.SalesOrder
                                                                                    and _CicloPo010.medicao     = '010'
  association        to ZI_SD_CICLO_PO                as _CicloPo011                on  _CicloPo011.ordem_venda = _SalesOrder.SalesOrder
                                                                                    and _CicloPo011.medicao     = '011'
  association        to ZI_SD_CICLO_PO                as _CicloPo012                on  _CicloPo012.ordem_venda = _SalesOrder.SalesOrder
                                                                                    and _CicloPo012.medicao     = '012'
  association        to ZI_SD_CICLO_PO                as _CicloPo013                on  _CicloPo013.ordem_venda = _SalesOrder.SalesOrder
                                                                                    and _CicloPo013.medicao     = '013'
  association        to ZI_SD_CICLO_PO                as _CicloPo014                on  _CicloPo014.ordem_venda = _SalesOrder.SalesOrder
                                                                                    and _CicloPo014.medicao     = '014'
  association        to ZI_SD_CICLO_PO                as _CicloPo015                on  _CicloPo015.ordem_venda = _SalesOrder.SalesOrder
                                                                                    and _CicloPo015.medicao     = '015'
  association        to ZI_SD_CICLO_PO                as _CicloPo016                on  _CicloPo016.ordem_venda = _SalesOrder.SalesOrder
                                                                                    and _CicloPo016.medicao     = '016'
  association        to ZI_SD_CICLO_PO                as _CicloPo017                on  _CicloPo017.ordem_venda = _SalesOrder.SalesOrder
                                                                                    and _CicloPo017.medicao     = '017'
  association        to ZI_SalesDocumentQuiqkView     as _ZI_SalesDocumentQuickView on  _ZI_SalesDocumentQuickView.SalesDocument = $projection.SalesOrder

  association        to ZI_SD_CKPT_FAT_VLR_MIN_OV     as _ValorMinimoOv             on  _ValorMinimoOv.SalesOrderCondition = _SalesOrder.SalesOrderCondition
                                                                                    and _ValorMinimoOv.Item                = _Item.SalesOrderItem

  association        to ZI_SD_CKPT_FAT_VLR_PEND_OV    as _ValorPend                 on  _ValorPend.SalesOrder = $projection.SalesOrder

  association        to ZI_SD_CKPT_FAT_VALOR_TOTAL    as _ValorTotal                on  _ValorTotal.knumv = _SalesOrder.SalesOrderCondition

  association        to ZI_VH_SD_LPRIO                as _Lprio                     on  _Lprio.DeliveryPriority = $projection.DeliveryPriority

  association        to ZI_SD_CKPT_STATUS_DISP_HEADER as _Status1                   on  _Status1.SalesDocument = _Item2.SalesOrder
                                                                                    and _Status1.Status        = 'Indisponível'
                                                                                    and _Status1.StatusDf      = 'Indisponível'

  association        to ZI_SD_CKPT_STATUS_DISP_HEADER as _Status2                   on  _Status2.SalesDocument =  _Item2.SalesOrder
                                                                                    and _Status2.Status        =  'Indisponível'
                                                                                    and _Status2.StatusDf      <> 'Indisponível'

  association        to ZI_SD_CKPT_STATUS_DISP_HEADER as _Status3                   on  _Status3.SalesDocument =  _Item2.SalesOrder
                                                                                    and _Status3.Status        <> 'Indisponível'
                                                                                    and _Status3.StatusDf      =  'Indisponível'

  association        to ZI_SD_CKPT_STATUS_DISP_HEADER as _Status4                   on  _Status4.SalesDocument = _Item2.SalesOrder
                                                                                    and _Status4.Status        = 'Disponível'
                                                                                    and _Status4.StatusDf      = 'Disponível'
{
  key _SalesOrder.SalesOrder,
  key _Item.SalesOrderItem,
      _Partner.Customer,
      _Partner.CustomerName,
      _Partner.CodigoServico,
      _Partner.CodigoServicoTexto,
      _Partner.AreaAtendimento,
      _Partner.AreaAtendimentoTexto,
      _SalesOrder.SalesOrderType,
      _SalesOrder.CreationDate,
      _SalesOrder.CreationTime,
      _SalesOrder.CustomerGroup,
      _SalesOrder.CustomerPurchaseOrderType,
      _Item.Plant,
      _Centro.CentroDepFechado,
      _Item.StorageLocation,
      _Item.Route,
      _Item.Material,

      case _SalesOrder.DeliveryBlockReason
         when ' ' then 'Concluída'
         else 'Pendente'
      end                                          as StatusDeliveryBlockReason,

      case _SalesOrder.DeliveryBlockReason
           when ' ' then 3 --Verde
           else 1 --Vermelho
      end                                          as ColorDeliveryBlockReason,

      case _SalesOrder.TotalCreditCheckStatus
         when 'B' then 'Pendente'
         when 'C' then 'Pendente'
         else 'Concluída'
      end                                          as StatusTotalCreditCheckStatus,

      case _SalesOrder.TotalCreditCheckStatus
           when 'B' then 1 --red
           when 'C' then 1 --red
           else 3          --green
      end                                          as ColorTotalCreditCheckStatus,

      _Item.OrderQuantityUnit,
      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      _Mat.Saldo,

      //      case
      //        when _Mat.Saldo > 0 then 'Disponível'
      //        else 'Indisponível'
      //      end                                          as Disponibilidade,
      //
      //      case
      //        when _Mat.Saldo > 0 then 3 --Verde
      //        else 1 --Vermelho
      //      end                                          as ColorDisponibilidade,

      //      _Disp.ColorStatus,

      //      case
      //        when _SalesOrder.DeliveryBlockReason = ' ' then _LiberacaoComercial.DataLiberacao
      //        else cast('00000000' as abap.dats)
      //      end                                          as DataLiberacao,
      case when _LiberacaoComercial.DataLiberacao is not null and _LiberacaoComercial.HoraLiberacao is not null then
      concat( concat(   concat(   concat(substring( _LiberacaoComercial.DataLiberacao, 7, 2 ), '.'),
                      concat(   substring( _LiberacaoComercial.DataLiberacao, 5, 2 ), concat('.', substring( _LiberacaoComercial.DataLiberacao, 1, 4 )))),

                      concat('-', concat(   concat(substring( _LiberacaoComercial.HoraLiberacao, 1, 2 ), ':'),
                                concat(substring( _LiberacaoComercial.HoraLiberacao, 3, 2 ), ':')) )),

                      substring( _LiberacaoComercial.HoraLiberacao, 5, 2 ) )

                      else '00.00.0000-00:00:00'
                      end                          as DataLiberacao,

      //      concat( _LiberacaoComercial.DataLiberacao, concat( '-', _LiberacaoComercial.HoraLiberacao ) ) as DataLiberacao,

      _Comex.StatusDeliveryBlockReasonText         as StatusDeliveryBlockReasonComex,
      _Comex.ColorStatusDeliveryBlockReason        as ColorStatusDeliveryBlockReason,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      _SalesOrder.TotalNetAmount,
      _ValorTotal.ValorTotal                       as TotalNetAmount,
      _SalesOrder.TransactionCurrency,
      _SalesOrder.SalesOrganization,
      _SalesOrder.SalesOffice,
      _SalesOrder.DistributionChannel,
      _SalesOrderStatus.OverallSDProcessStatus     as StatusGlobalOV,
      _SalesOrderStatus.OverallSDProcessStatusDesc as StatusGlobalOVTexto,
      _OverallDeliveryStatus.OverallDeliveryStatus,
      _OverallDeliveryStatus.OverallDeliveryStatusDesc,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      _pesobruto.ItemGrossWeight,
      _pesobruto.ItemWeightUnit,
      _VendedorInt.Partner                         as PersonnelInt,
      _VendedorInt.PartnerName                     as PersonnelIntName,
      _VendedorExt.Partner                         as PersonnelExt,
      _VendedorExt.PartnerName                     as PersonnelExtName,
      _SalesOrder.SalesGroup,
      _SalesOrder.CustomerPurchaseOrderDate,
      _Partner.Regio,
      _SalesOrder.RequestedDeliveryDate,
      _datafat.data_fatura                         as DataFatura,
      _TipoAgendaCliente.GrupoClienteAgenda        as Agendamento,
      _TipoAgendaCliente.GrupoClienteAgendaTexto,
      //////      _Agendamento.DataAgendada                    as DataAgendamento,
      _DataAgenda.data_agendada                    as DataAgendamento,
      //      cast('' as flag preserving type )            as ValorMin,
      //      _ValorPend.VlrPendOV                         as VlrPendOVTeste,
      _ValorMinimoOv.ElementAmount,
      case
      when  _ValorPend.VlrPendOV >= _ValorMinimoOv.ElementAmount
      then 'Sim'
      when  _ValorPend.VlrPendOV < _ValorMinimoOv.ElementAmount
      then 'Não'
      else 'N/A'
      end                                          as ValorMin,

      case
      when  _ValorPend.VlrPendOV >= _ValorMinimoOv.ElementAmount
      then 3
      when _ValorPend.VlrPendOV < _ValorMinimoOv.ElementAmount
      then 1
      else 0
      end                                          as ColorValorMin,

      _SalesOrder.PurchaseOrderByShipToParty       as CorrespncExternalReference,
      _CicloPo001.data_hora_planejada              as Sincronismo,
      _CicloPo002.data_hora_planejada              as AprovacaoComercial,
      _CicloPo003.data_hora_planejada              as AprovacaoCredito,
      _CicloPo004.data_hora_planejada              as EnvioRoteirizacao,
      _CicloPo005.data_hora_planejada              as CriacaoOrdemFrete,
      _CicloPo006.data_hora_planejada              as Faturamento,
      _CicloPo007.data_hora_planejada              as SaidaVeiculo,
      _CicloPo008.data_hora_planejada              as Entrega,
      _CicloPo009.data_hora_planejada              as SLAExterno,
      _CicloPo010.data_hora_planejada              as SLAInterno,
      _CicloPo011.data_hora_planejada              as SLAGeral,
      _CicloPo012.data_hora_planejada              as GeracaoRemessa,
      _CicloPo013.data_hora_planejada              as Estoque,
      _CicloPo014.data_hora_planejada              as AprovacaoNFe,
      _CicloPo015.data_hora_planejada              as ImpressaoNFe,
      _CicloPo016.data_hora_planejada              as PrestacaoContas,
      _CicloPo017.data_hora_planejada              as Carregamento,

      //      _ValorMinimoOv.ElementAmount                                    as ValorMinOv,
      //      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      cast( round(  _ValorMinimoOv.ElementAmount,2 ) as abap.dec( 24,2 ) ) as ValorMinOv,

      case
      when  _ValorMinimoOv.ElementAmount = 0
      then ' '
      else  REPLACE( concat_with_space( cast( _ValorMinimoOv.ElementAmount as abap.char( 26) ),  cast( _SalesOrder.TransactionCurrency as ze_moeda_char ) , 1  ) , '.' , ',' )
      end                                          as ValorMinOv,


      //      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      cast( _ValorPend.VlrPendOV as abap.dec( 15, 2 ) )                    as VlrPendOV,

      //      case
      //      when  _ValorPend.VlrPendOV = 0
      //      then ' '
      //      else REPLACE( concat_with_space(cast( _ValorPend.VlrPendOV as abap.char(31) ), concat( '', cast( _SalesOrder.TransactionCurrency as ze_moeda_char ) ) , 1  ) , '.' , ',' )
      //      end                                          as VlrPendOV,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _ValorPend.VlrPendOV                         as VlrPendOV,
      _Aux.CorrespncExternalReference              as PedidoAux,


      case
      when _Status1.Status <> ''
      then _Status1.Status
      when _Status2.Status <> ''
      then _Status2.Status
      when _Status3.Status <> ''
      then _Status3.Status
      when _Status4.Status <> ''
      then _Status4.Status
      else ''
      end                                          as Status,

      case
      when _Status1.ColorStatus is not null
      then _Status1.ColorStatus
      when _Status2.ColorStatus is not null
      then _Status2.ColorStatus
      when _Status3.ColorStatus is not null
      then _Status3.ColorStatus
      when _Status4.ColorStatus is not null
      then _Status4.ColorStatus
      else 0
      end                                          as ColorStatus,

      case
      when _Status1.StatusDf <> ''
      then _Status1.StatusDf
      when _Status2.StatusDf <> ''
      then _Status2.StatusDf
      when _Status3.StatusDf <> ''
      then _Status3.StatusDf
      when _Status4.StatusDf <> ''
      then _Status4.StatusDf
      else ''
      end                                          as StatusDF,

      case
      when _Status1.ColorStatusDf is not null
      then _Status1.ColorStatusDf
      when _Status2.ColorStatusDf is not null
      then _Status2.ColorStatusDf
      when _Status3.ColorStatusDf is not null
      then _Status3.ColorStatusDf
      when _Status4.ColorStatusDf is not null
      then _Status4.ColorStatusDf
      else 0
      end                                          as ColorStatusDF,

      _Item.DeliveryPriority,
      _Lprio.DeliveryPriorityDesc,
      _ZI_SalesDocumentQuickView
}
where
      _SalesOrder.DeliveryBlockReason           <> 'C'
  and _SalesOrder.OverallSDDocumentRejectionSts <> 'C'
  and _SalesOrder.OverallSDProcessStatus        <> 'C'
//  and _Item.SalesOrderItem                      =  '000010'
group by
  _SalesOrder.SalesOrder,
  _Item.SalesOrderItem,
  _Partner.Customer,
  _Partner.CustomerName,
  _Partner.CodigoServico,
  _Partner.CodigoServicoTexto,
  _Partner.AreaAtendimento,
  _Partner.AreaAtendimentoTexto,
  _ValorPend.VlrPendOV,
  _SalesOrder.CreationDate,
  _SalesOrder.CustomerGroup,
  _SalesOrder.CustomerPurchaseOrderType,
  _Item.Material,
  _Item.OrderQuantityUnit,
  _Item.Plant,
  _Centro.CentroDepFechado,
  _Item.StorageLocation,
  _Item.Route,
  _Mat.Saldo,
  _Status1.Status,
  _Status2.Status,
  _Status3.Status,
  _Status4.Status,
  _Status1.ColorStatus,
  _Status2.ColorStatus,
  _Status3.ColorStatus,
  _Status4.ColorStatus,
  _Status1.StatusDf,
  _Status2.StatusDf,
  _Status3.StatusDf,
  _Status4.StatusDf,
  _Status1.ColorStatusDf,
  _Status2.ColorStatusDf,
  _Status3.ColorStatusDf,
  _Status4.ColorStatusDf,
  //  _Disp.Status,
  //  _Disp.ColorStatus,
  _SalesOrder.SalesOrderType,
  _SalesOrder.DeliveryBlockReason,
  _SalesOrder.TotalCreditCheckStatus,
  //  _SalesOrder.TotalNetAmount,
  _ValorTotal.ValorTotal,
  _SalesOrder.SalesOrganization,
  _SalesOrder.TransactionCurrency,
  _SalesOrder.SalesOffice,
  _SalesOrder.DistributionChannel,
  _SalesOrder.CreationTime,
  _SalesOrderStatus.OverallSDProcessStatus,
  _SalesOrderStatus.OverallSDProcessStatusDesc,
  _pesobruto.ItemGrossWeight,
  _pesobruto.ItemWeightUnit,
  _VendedorInt.Partner,
  _VendedorInt.PartnerName,
  _VendedorExt.Partner,
  _VendedorExt.PartnerName,
  _SalesOrder.SalesGroup,
  _SalesOrder.CustomerPurchaseOrderDate,
  _Partner.Regio,
  _SalesOrder.RequestedDeliveryDate,
  _datafat.data_fatura,
  _LiberacaoComercial.SalesOrder,
  _LiberacaoComercial.DataLiberacao,
  _LiberacaoComercial.HoraLiberacao,
  _TipoAgendaCliente.GrupoClienteAgenda,
  _TipoAgendaCliente.GrupoClienteAgendaTexto,
  //  _Agendamento.DataAgendada,
  _DataAgenda.data_agendada,
  _Comex.StatusDeliveryBlockReasonText,
  _Comex.ColorStatusDeliveryBlockReason,
  _OverallDeliveryStatus.OverallDeliveryStatus,
  _OverallDeliveryStatus.OverallDeliveryStatusDesc,
  _SalesOrder.PurchaseOrderByShipToParty,
  _CicloPo001.data_hora_planejada,
  _CicloPo002.data_hora_planejada,
  _CicloPo003.data_hora_planejada,
  _CicloPo004.data_hora_planejada,
  _CicloPo005.data_hora_planejada,
  _CicloPo006.data_hora_planejada,
  _CicloPo007.data_hora_planejada,
  _CicloPo008.data_hora_planejada,
  _CicloPo009.data_hora_planejada,
  _CicloPo010.data_hora_planejada,
  _CicloPo011.data_hora_planejada,
  _CicloPo012.data_hora_planejada,
  _CicloPo013.data_hora_planejada,
  _CicloPo014.data_hora_planejada,
  _CicloPo015.data_hora_planejada,
  _CicloPo016.data_hora_planejada,
  _CicloPo017.data_hora_planejada,
  _ValorMinimoOv.ElementAmount,
  _ValorPend.VlrPendOV,
  _Aux.CorrespncExternalReference,
  _Item.DeliveryPriority,
  _Lprio.DeliveryPriorityDesc
