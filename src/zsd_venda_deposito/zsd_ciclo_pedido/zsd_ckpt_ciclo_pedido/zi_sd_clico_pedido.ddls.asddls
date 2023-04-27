@AbapCatalog.sqlViewName: 'ZVSDCLICOPED'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta Ciclo de pedido'
define view zi_sd_clico_pedido  as select from    I_SalesOrder                             as _salesorder
    left outer join ZI_SD_CKPT_CICLO_PED_FLOW( p_tipo : 'J') as _remessa on _remessa.SalesOrder = _salesorder.SalesOrder
    left outer join ZI_SD_CKPT_CICLO_PED_FLOW( p_tipo : 'M') as _fatura  on _remessa.SalesOrder = _salesorder.SalesOrder
  association to ZI_SD_JUSTIF_ATRASO_TO       as _ordemPedidos   on  _ordemPedidos.SalesOrder = _salesorder.SalesOrder
  association to ZI_SD_CKPT_CICLO_PEDIDO_ITEM as _salesorderitem on  _salesorderitem.SalesOrder = $projection.SalesOrder
  association to ZI_SD_CKPT_CICLO_PED_PARTNER as _partner        on  _partner.SalesOrder = $projection.SalesOrder

  association to ztsd_ciclo_po                as _sincronismo    on  _sincronismo.ordem_venda = $projection.SalesOrder
                                                                 and _sincronismo.medicao     = '001' //Sincronismo

  association to ztsd_ciclo_po                as _aprvComercial  on  _aprvComercial.ordem_venda = $projection.SalesOrder
                                                                 and _aprvComercial.medicao     = '002' //Aprovação Comercial

  association to ztsd_ciclo_po                as _aprvCredito    on  _aprvCredito.ordem_venda = $projection.SalesOrder
                                                                 and _aprvCredito.medicao     = '003' //Aprovação Crédito

  association to ztsd_ciclo_po                as _envioRemessa   on  _envioRemessa.ordem_venda = $projection.SalesOrder
                                                                 and _envioRemessa.medicao     = '004' //Envio Roteirização

  association to ztsd_ciclo_po                as _ordemFrete     on  _ordemFrete.ordem_venda = $projection.SalesOrder
                                                                 and _ordemFrete.medicao     = '005' //Criação da Ordem de Frete

  association to ztsd_ciclo_po                as _faturamento    on  _faturamento.ordem_venda = $projection.SalesOrder
                                                                 and _faturamento.medicao     = '006' //Faturamento

  association to ztsd_ciclo_po                as _saida          on  _saida.ordem_venda = $projection.SalesOrder
                                                                 and _saida.medicao     = '007' //Saída do Veículo

  association to ztsd_ciclo_po                as _entrega        on  _entrega.ordem_venda = $projection.SalesOrder
                                                                 and _entrega.medicao     = '008' //Entrega

  association to ztsd_ciclo_po                as _cicloExterno   on  _cicloExterno.ordem_venda = $projection.SalesOrder
                                                                 and _cicloExterno.medicao     = '009' //SLA Externomj

  association to ztsd_ciclo_po                as _cicloInterno   on  _cicloInterno.ordem_venda = $projection.SalesOrder
                                                                 and _cicloInterno.medicao     = '010' //SLA Interno

  association to ztsd_ciclo_po                as _cicloGlobal    on  _cicloGlobal.ordem_venda = $projection.SalesOrder
                                                                 and _cicloGlobal.medicao     = '011' //SLA Geral

  association to ztsd_ciclo_po                as _geracaoremessa on  _geracaoremessa.ordem_venda = $projection.SalesOrder
                                                                 and _geracaoremessa.medicao     = '012' //Geração da remessa

  association to ztsd_ciclo_po                as _estoque        on  _estoque.ordem_venda = $projection.SalesOrder
                                                                 and _estoque.medicao     = '013' //Estoque

  association to ztsd_ciclo_po                as _aprvNFE        on  _aprvNFE.ordem_venda = $projection.SalesOrder
                                                                 and _aprvNFE.medicao     = '014' //Aprovação da NF-e

  association to ztsd_ciclo_po                as _impNFE         on  _impNFE.ordem_venda = $projection.SalesOrder
                                                                 and _impNFE.medicao     = '015' //Impressão da NF-e

  association to ztsd_ciclo_po                as _prestContas    on  _prestContas.ordem_venda = $projection.SalesOrder
                                                                 and _prestContas.medicao     = '016' //Prestação de contas

  association to ztsd_ciclo_po                as _carregamento   on  _carregamento.ordem_venda = $projection.SalesOrder
                                                                 and _carregamento.medicao     = '017' //Carregamento
{

  key _salesorder.SalesOrder,

      _remessa.Document                   as Remessa,
      _salesorderitem.Route,
      _salesorder.SoldToParty,
      _salesorder.OverallSDProcessStatus,

      case when _sincronismo.data_hora_realizada > _sincronismo.data_hora_planejada then 'Realizada em Atraso'
      when _sincronismo.data_hora_realizada <= _sincronismo.data_hora_planejada then 'Realizada no Prazo'
      else 'Ainda nao realizada'
      end                                 as StatusSincronismo, //Status sincronismo

      case when _aprvComercial.data_hora_realizada > _aprvComercial.data_hora_planejada then 'Realizada em Atraso'
      when _aprvComercial.data_hora_realizada <= _aprvComercial.data_hora_planejada then 'Realizada no Prazo'
      else 'Ainda nao realizada'
      end                                 as StatusAprvComercial, //Status aprovação comercial

      case when _aprvCredito.data_hora_realizada > _aprvCredito.data_hora_planejada then 'Realizada em Atraso'
      when _aprvCredito.data_hora_realizada <= _aprvCredito.data_hora_planejada then 'Realizada no Prazo'
      else 'Ainda nao realizada'
      end                                 as StatusAprvCredito, //Status aprovação de crédito

      case when _envioRemessa.data_hora_realizada > _envioRemessa.data_hora_planejada then 'Realizada em Atraso'
      when _envioRemessa.data_hora_realizada <= _envioRemessa.data_hora_planejada then 'Realizada no Prazo'
      else 'Ainda nao realizada'
      end                                 as StatusEnvioRemessa, //Status envio de remessa

      case when _ordemFrete.data_hora_realizada > _ordemFrete.data_hora_planejada then 'Realizada em Atraso'
      when _ordemFrete.data_hora_realizada <= _ordemFrete.data_hora_planejada then 'Realizada no Prazo'
      else 'Ainda nao realizada'
      end                                 as StatusOrdemFrete, //Status ordem de frete

      case when _faturamento.data_hora_realizada > _faturamento.data_hora_planejada then 'Realizada em Atraso'
      when _faturamento.data_hora_realizada <= _faturamento.data_hora_planejada then 'Realizada no Prazo'
      else 'Ainda nao realizada'
      end                                 as StatusFaturamento, //Status faturamento

      case when _saida.data_hora_realizada > _saida.data_hora_planejada then 'Realizada em Atraso'
      when _saida.data_hora_realizada <= _saida.data_hora_planejada then 'Realizada no Prazo'
      else 'Ainda nao realizada'
      end                                 as StatusSaida, //Status saída de veículo

      case when _entrega.data_hora_realizada > _entrega.data_hora_planejada then 'Realizada em Atraso'
      when _entrega.data_hora_realizada <= _entrega.data_hora_planejada then 'Realizada no Prazo'
      else 'Ainda nao realizada'
      end                                 as StatusEntrega, //Status entrega ao cliente

      case when _cicloInterno.data_hora_realizada > _cicloInterno.data_hora_planejada then 'Realizada em Atraso'
      when _cicloInterno.data_hora_realizada <= _cicloInterno.data_hora_planejada then 'Realizada no Prazo'
      else 'Ainda nao realizada'
      end                                 as StatusCicloInterno, //Status ciclo interno

      case when _cicloExterno.data_hora_realizada > _cicloExterno.data_hora_planejada then 'Realizada em Atraso'
      when _cicloExterno.data_hora_realizada <= _cicloExterno.data_hora_planejada then 'Realizada no Prazo'
      else 'Ainda nao realizada'
      end                                 as StatusCicloExterno, //Status ciclo externo

      case when _cicloGlobal.data_hora_realizada > _cicloGlobal.data_hora_planejada then 'Realizada em Atraso'
      when _cicloGlobal.data_hora_realizada <= _cicloGlobal.data_hora_planejada then 'Realizada no Prazo'
      else 'Ainda nao realizada'
      end                                 as StatusCicloGlobal,  //Status ciclo global

      case when _geracaoremessa.data_hora_realizada > _geracaoremessa.data_hora_planejada then 'Realizada em Atraso'
      when _geracaoremessa.data_hora_realizada <= _geracaoremessa.data_hora_planejada then 'Realizada no Prazo'
      else 'Ainda nao realizada'
      end                                 as StatusGeracaoRemessa, //Geração da remessa

      case when _estoque.data_hora_realizada > _estoque.data_hora_planejada then 'Realizada em Atraso'
      when _estoque.data_hora_realizada <= _estoque.data_hora_planejada then 'Realizada no Prazo'
      else 'Ainda nao realizada'
      end                                 as StatusEstoque, //Estoque

      case when _aprvNFE.data_hora_realizada > _aprvNFE.data_hora_planejada then 'Realizada em Atraso'
      when _aprvNFE.data_hora_realizada <= _aprvNFE.data_hora_planejada then 'Realizada no Prazo'
      else 'Ainda nao realizada'
      end                                 as StatusAprovacaoNFE, //Aprovação da NF-e

      case when _impNFE.data_hora_realizada > _impNFE.data_hora_planejada then 'Realizada em Atraso'
      when _impNFE.data_hora_realizada <= _impNFE.data_hora_planejada then 'Realizada no Prazo'
      else 'Ainda nao realizada'
      end                                 as StatusImpressaoNFE, //Impressão da NF-e

      case when _prestContas.data_hora_realizada > _prestContas.data_hora_planejada then 'Realizada em Atraso'
      when _prestContas.data_hora_realizada <= _prestContas.data_hora_planejada then 'Realizada no Prazo'
      else 'Ainda nao realizada'
      end                                 as StatusPrestacaoContas, //Prestação de contas

      case when _carregamento.data_hora_realizada > _carregamento.data_hora_planejada then 'Realizada em Atraso'
      when _carregamento.data_hora_realizada <= _carregamento.data_hora_planejada then 'Realizada no Prazo'
      else 'Ainda nao realizada'
      end                                 as StatusCarregamento, //Carregamento

      _salesorderitem.Plant,
      _salesorder.SalesOrderType,
      _partner.Personnel,
      _ordemPedidos.OrdemFrete, //Ordem de frete
      _fatura.Document                    as Fatura,
      _fatura.NotaFiscal,
      _salesorder.RequestedDeliveryDate,
      //Data de agenda  gap id 421
      _salesorder.SalesOrderDate,
      _salesorder.AdditionalCustomerGroup5,
      _sincronismo.data_hora_planejada    as DataPlanejadaSincronismo, //Data planejada sincronismo
      _aprvComercial.data_hora_planejada  as DataPlanejadaAprovComercial, //Data planejada aprovação comercial
      _aprvCredito.data_hora_planejada    as DataPlanejadaAprovCredito, //Data planejada aprovação de crédito
      _envioRemessa.data_hora_planejada   as DataPlanejadaEnvioDeRemessa, //Data planejada envio de remessa
      _ordemFrete.data_hora_planejada     as DataPlanejadaOrdemFrete, //Data planejada ordem de frete
      _faturamento.data_hora_planejada    as DataPlanejadaFaturamento, //Data planejada faturamento
      _saida.data_hora_planejada          as DataPlanejadaSaida, //Data planejada saída do veículo
      _entrega.data_hora_planejada        as DataPlanejadaEntrega, //Data planejada da entrega ao cliente
      _cicloExterno.data_hora_planejada   as DataPlanejadaCicloExterno, //Data planejada ciclo externo
      _cicloInterno.data_hora_planejada   as DataPlanejadaCicloInterno, //Data planejada ciclo interno
      _cicloGlobal.data_hora_planejada    as DataPlanejadaCicloTotal, //Data planejada ciclo total
      _geracaoremessa.data_hora_planejada as DataPlanejadaGeracaoRemessa, //Data planejada geração da remessa
      //Data planejada verificação de estoque
      _aprvNFE.data_hora_planejada        as DataPlanejadaAprovacaoNFE, //Data planejada aprovação NF-e
      _impNFE.data_hora_planejada         as DataPlanejadaImpressaoNFE, //Data planejada impressão NF-e
      _prestContas.data_hora_planejada    as DataPlanejadaPretacaoDeContas, //Data planejada prestação de contas
      _carregamento.data_hora_planejada   as DataPlanejadaCarregamento, //Data planejada carregamento
      _sincronismo.data_hora_realizada    as DataRealizadaSincronismo,  //Data realizada sincronismo
      //Data realizada aprovação comercial
      //Data realizada aprovação de crédito
      //Data realizada envio de remessa
      //Data realizada ordem de frete
      //Data realizada faturamento
      //Data realizada saída do veículo
      //Data realizada entrega ao cliente
      //Data realizada ciclo interno
      //Data realizada ciclo externo
      //Data realizada ciclo total
      //Data realizada geração da remessa
      //Data realizada verificação de estoque
      //Data realizada aprovação NF-e
      //Data realizada  impressão NF-e
      //Data realizada  prestação de contas
      _salesorder.OrganizationDivision,
      _salesorder.SalesOffice,
      _salesorder.SalesGroup,
      //Grupo de clientes
      _salesorder.SalesOrganization,
      _salesorder.CustomerPurchaseOrderDate

}
