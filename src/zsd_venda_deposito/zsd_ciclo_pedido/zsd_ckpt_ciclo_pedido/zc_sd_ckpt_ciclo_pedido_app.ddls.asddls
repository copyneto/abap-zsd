@EndUserText.label: 'CockPit do Ciclo do Pedido'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_SD_CKPT_CICLO_PEDIDO_APP
  as projection on ZI_SD_CKPT_CICLO_PEDIDO_APP
{
  key SalesOrder,
      Remessa,
      @Consumption.valueHelpDefinition: [
      { entity:  { name:    'C_TripRouteVH',
              element: 'Router' }
      }]
      Route,
      @Consumption.valueHelpDefinition: [
       { entity:  { name:    'I_Customer_VH',
                    element: 'Customer' }
       }]
      SoldToParty,
      OverallSDProcessStatus,
      @EndUserText.label: 'Status - Sincronismo'
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STATUS_PEDIDOS', element: 'Texto' }}]
      StatusSincronismo,
      @EndUserText.label: 'Status - Aprovação Comercial'
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STATUS_PEDIDOS', element: 'Texto' }}]
      StatusAprvComercial,
      @EndUserText.label: 'Status - Aprovação de Credito'
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STATUS_PEDIDOS', element: 'Texto' }}]
      StatusAprvCredito,
      @EndUserText.label: 'Status - Envio de Remessa'
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STATUS_PEDIDOS', element: 'Texto' }}]
      StatusEnvioRemessa,
      @EndUserText.label: 'Status - Ordem de Frete'
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STATUS_PEDIDOS', element: 'Texto' }}]
      StatusOrdemFrete,
      @EndUserText.label: 'Status - Faturamento'
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STATUS_PEDIDOS', element: 'Texto' }}]
      StatusFaturamento,
      @EndUserText.label: 'Status - Data de Saída'
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STATUS_PEDIDOS', element: 'Texto' }}]
      StatusSaida,
      @EndUserText.label: 'Status - Data de Entrega'
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STATUS_PEDIDOS', element: 'Texto' }}]
      StatusEntrega,
      @EndUserText.label: 'Status - Ciclo Interno'
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STATUS_PEDIDOS', element: 'Texto' }}]
      StatusCicloInterno,
      @EndUserText.label: 'Status - Ciclo Externo'
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STATUS_PEDIDOS', element: 'Texto' }}]
      StatusCicloExterno,
      @EndUserText.label: 'Status - Ciclo Global'
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STATUS_PEDIDOS', element: 'Texto' }}]
      StatusCicloGlobal,
      @EndUserText.label: 'Status - Geração de Remessa'
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STATUS_PEDIDOS', element: 'Texto' }}]
      StatusGeracaoRemessa,
      @EndUserText.label: 'Status - Estoque'
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STATUS_PEDIDOS', element: 'Texto' }}]
      StatusEstoque,
      @EndUserText.label: 'Status - Aprovação da NFe'
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STATUS_PEDIDOS', element: 'Texto' }}]
      StatusAprovacaoNFE,
      @EndUserText.label: 'Status - Impressão da NFe'
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STATUS_PEDIDOS', element: 'Texto' }}]
      StatusImpressaoNFE,
      @EndUserText.label: 'Status - Prestação de Contas'
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STATUS_PEDIDOS', element: 'Texto' }}]
      StatusPrestacaoContas,
      @EndUserText.label: 'Status - Carregamento'
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STATUS_PEDIDOS', element: 'Texto' }}]
      StatusCarregamento,
      @EndUserText.label: 'Status - Verificação do Estoque'
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STATUS_PEDIDOS', element: 'Texto' }}]
      StatusVerificacaoEstoque,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_WERKS', element: 'WerksCode' }}]
      Plant,
      SalesOrderType,
      Personnel,
      OrdemFrete,
      Fatura,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_DOCNUM', element: 'BR_NFeNumber' }}]
      NotaFiscal,
      RequestedDeliveryDate,
      SalesOrderDate,
      AdditionalCustomerGroup5,

      @EndUserText.label: 'Data Planejada - Sincronismo'
      DataPlanejadaSincronismo,
      @EndUserText.label: 'Data Planejada - Aprovação Comercial'
      DataPlanejadaAprovComercial,
      @EndUserText.label: 'Data Planejada - Aprovação de Credito'
      DataPlanejadaAprovCredito,
      @EndUserText.label: 'Data Planejada - Envio de Remessa'
      DataPlanejadaEnvioDeRemessa,
      @EndUserText.label: 'Data Planejada - Ordem de Frete'
      DataPlanejadaOrdemFrete,
      @EndUserText.label: 'Data Planejada - Faturamento'
      DataPlanejadaFaturamento,
      @EndUserText.label: 'Data Planejada - Data de Saída'
      DataPlanejadaSaida,
      @EndUserText.label: 'Data Planejada - Data de Entrega'
      DataPlanejadaEntrega,
      @EndUserText.label: 'Data Planejada - Ciclo Interno'
      DataPlanejadaCicloExterno,
      @EndUserText.label: 'Data Planejada - Ciclo Externo'
      DataPlanejadaCicloInterno,
      @EndUserText.label: 'Data Planejada - Ciclo Global'
      DataPlanejadaCicloTotal,
      @EndUserText.label: 'Data Planejada - Geração de Remessa'
      DataPlanejadaGeracaoRemessa,
      @EndUserText.label: 'Data Planejada - Verificação do Estoque'
      DataPlanejadaVerifEstoque,
      @EndUserText.label: 'Data Planejada - Aprovação da NFe'
      DataPlanejadaAprovacaoNFE,
      @EndUserText.label: 'Data Planejada - Impressão da NFe'
      DataPlanejadaImpressaoNFE,
      @EndUserText.label: 'Data Planejada - Prestação de Contas'
      DataPlanejadaPretacaoDeContas,
      @EndUserText.label: 'Data Planejada - Carregamento'
      DataPlanejadaCarregamento,
      @EndUserText.label: 'Data Planejada - Estoque'
      DataPlanejadaEstoque,

      @EndUserText.label: 'Data Realizada - Sincronismo'
      DataRealizadaSincronismo,
      @EndUserText.label: 'Data Realizada - Aprovação Comercial'
      DataRealizadaAprovComercial,
      @EndUserText.label: 'Data Realizada - Aprovação de Credito'
      DataRealizadaAprovCredito,
      @EndUserText.label: 'Data Realizada - Envio de Remessa'
      DataRealizadaEnvioDeRemessa,
      @EndUserText.label: 'Data Realizada - Ordem de Frete'
      DataRealizadaOrdemFrete,
      @EndUserText.label: 'Data Realizada - Faturamento'
      DataRealizadaFaturamento,
      @EndUserText.label: 'Data Realizada - Data de Saída'
      DataRealizadaSaida,
      @EndUserText.label: 'Data Realizada - Data de Entrega'
      DataRealizadaEntrega,
      @EndUserText.label: 'Data Realizada - Ciclo Interno'
      DataRealizadaCicloInterno,
      @EndUserText.label: 'Data Realizada - Ciclo Externo'
      DataRealizadaCicloExterno,
      @EndUserText.label: 'Data Realizada - Ciclo Global'
      DataRealizadaCicloTotal,
      @EndUserText.label: 'Data Realizada - Geração de Remessa'
      DataRealizadaGeracaoRemessa,
      @EndUserText.label: 'Data Realizada - Verificação do Estoque'
      DataRealizadaVerifEstoque,
      @EndUserText.label: 'Data Realizada - Aprovação da NFe'
      DataRealizadaAprovacaoNFE,
      @EndUserText.label: 'Data Realizada - Impressão da NFe'
      DataRealizadaImpressaoNFE,
      @EndUserText.label: 'Data Realizada - Prestação de Contas'
      DataRealizadaPretacaoDeContas,
      @EndUserText.label: 'Data Realizada - Carregamento'
      DataRealizadaCarregamento,
      @EndUserText.label: 'Data Realizada - Estoque'
      DataRealizadaEstoque,
      OrganizationDivision,
      SalesOffice,
      SalesGroup,
      SalesOrganization,
      CustomerPurchaseOrderDate,
      DistributionChannel,


      /* Status Colors */
      StatusSincronismoCrit,
      StatusAprvComercialCrit,
      StatusAprvCreditoCrit,
      StatusEnvioRemessaCrit,
      StatusOrdemFreteCrit,
      StatusFaturamentoCrit,
      StatusSaidaCrit,
      StatusEntregaCrit,
      StatusCicloInternoCrit,
      StatusCicloExternoCrit,
      StatusCicloGlobalCrit,
      StatusGeracaoRemessaCrit,
      StatusEstoqueCrit,
      StatusAprovacaoNFECrit,
      StatusImpressaoNFECrit,
      StatusPrestacaoContasCrit,
      StatusCarregamentoCrit,
      StatusVerificacaoEstoqueCrit
}
