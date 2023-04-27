@EndUserText.label: 'Cockpit Faturamento'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_SD_CKPT_FAT_APP
  as projection on ZI_SD_CKPT_FAT_APP as App
{
          @EndUserText.label: 'Ordem de cliente'
          @Consumption.semanticObject: 'SalesDocument'
          @ObjectModel.foreignKey.association: '_ZI_SalesDocumentQuickView'
  key     SalesOrder,
          @EndUserText.label: 'Item'
          //     @Consumption.filter : {  selectionType: #SINGLE, defaultValue: '010' }
          @Consumption.filter.hidden: true
  key     SalesOrderItem,
          @EndUserText.label: 'Emissor da Ordem'
          //@ObjectModel.text.element: ['CustomerName']
          Customer,
          @EndUserText.label: 'Nome do Emissor da ordem'
          CustomerName,
          @EndUserText.label: 'Tipo de Ordem'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_AUART', element: 'SalesDocumentType' } } ]
          SalesOrderType,
          @EndUserText.label: 'Data da criação da ordem'
          CreationDate,
          @EndUserText.label: 'Hora criação da ordem'
          CreationTime,
          @EndUserText.label: 'Grupo Clientes'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CustomerGroup', element: 'CustomerGroup' } } ]
          CustomerGroup,
          @EndUserText.label: 'Tipo de Pedido'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_TIPO_PEDIDO_CLIENTE', element: 'Bsark' } } ]
          CustomerPurchaseOrderType,
          @EndUserText.label: 'Lib.Comercial'
          StatusDeliveryBlockReason,
          ColorDeliveryBlockReason,
          //          @Consumption.filter.hidden: true
          //          OrderQuantityUnit,
          //          Saldo,
          @ObjectModel: { virtualElement: true,
          virtualElementCalculatedBy: 'ABAP:ZCLSD_CKPT_FAT_STATUSFT' }
          @EndUserText.label: 'Disponibilidade'
  virtual Status        : abap.char(15),

          @ObjectModel: { virtualElement: true,
          virtualElementCalculatedBy: 'ABAP:ZCLSD_CKPT_FAT_STATUSFT' }
  virtual ColorStatus   : int1,

          @ObjectModel: { virtualElement: true,
          //          virtualElementCalculatedBy: 'ABAP:ZCLSD_CKPT_FAT_STATUSDF' }
          virtualElementCalculatedBy: 'ABAP:ZCLSD_CKPT_FAT_STATUSFT' }
          @EndUserText.label: 'Disponibilidade DF'
  virtual StatusDF      : abap.char(15),

          @ObjectModel: { virtualElement: true,
          //          virtualElementCalculatedBy: 'ABAP:ZCLSD_CKPT_FAT_STATUSDF' }
          virtualElementCalculatedBy: 'ABAP:ZCLSD_CKPT_FAT_STATUSFT' }
  virtual ColorStatusDF : int1,

          @EndUserText.label: 'Lib.Crédito'
          StatusTotalCreditCheckStatus,
          ColorTotalCreditCheckStatus,
          @EndUserText.label: 'Valor total'
          TotalNetAmount,
          @EndUserText.label: 'Moeda'
          TransactionCurrency,
          @Consumption.filter.mandatory: true
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_SALESORG', element: 'SalesOrgID' }}]
          @EndUserText.label: 'Organização de vendas'
          SalesOrganization,
          @EndUserText.label: 'Escritório de vendas'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VKBUR', element: 'SalesOffice' } } ]
          SalesOffice,
          @EndUserText.label: 'Canal de distribuição'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VTWEG', element: 'CanalDistrib' } } ]
          DistributionChannel,
          @EndUserText.label: 'Peso Bruto'
          ItemGrossWeight,
          @EndUserText.label: 'Unid.Peso Bruto'
          ItemWeightUnit,
          //      @EndUserText.label: 'Vendedor'
          //      Personnel,
          @EndUserText.label: 'Vendedor Interno'
          //          @ObjectModel.text.element: ['PersonnelIntName']
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_LIFNR', element: 'LifnrCode' } } ]
          PersonnelInt,
          @EndUserText.label: 'Descrição Vendedor Interno'
          PersonnelIntName,
          @EndUserText.label: 'Vendedor Externo'
          //          @ObjectModel.text.element: ['PersonnelExtName']
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_LIFNR', element: 'LifnrCode' } } ]
          PersonnelExt,
          @EndUserText.label: 'Descrição Vendedor Externo'
          PersonnelExtName,
          @EndUserText.label: 'Equipe de vendas'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VKGRP', element: 'SalesGroup' } } ]
          SalesGroup,
          @EndUserText.label: 'Data Pré Pedido'
          CustomerPurchaseOrderDate,
          @EndUserText.label: 'Região'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_REGIO_BR', element: 'Region' } } ]
          Regio,
          @EndUserText.label: 'Data desejada de remessa'
          RequestedDeliveryDate,
          @EndUserText.label: 'Data faturamento'
          DataFatura,
          @EndUserText.label: 'Data da liberação comercial'
          //@Consumption.filter : {  selectionType: #INTERVAL, defaultValue: #( $session.system_date ) }
          DataLiberacao,
          @EndUserText.label: 'Grupo de Agendamento'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_KVGR5_NEW', element: 'AdditionalCustomerGroup5' } } ]
          @ObjectModel.text.element: ['GrupoClienteAgendaTexto']
          Agendamento,
          @UI.hidden: true
          @Consumption.filter.hidden: true
          GrupoClienteAgendaTexto,
          @EndUserText.label: 'Status atendimento da ordem'
          @ObjectModel.text.element: ['OverallDeliveryStatusDesc']
          OverallDeliveryStatus,
          @Consumption.filter.hidden: true
          OverallDeliveryStatusDesc,
          @EndUserText.label: 'Status Global Ordem'
          //          @ObjectModel.text.element: ['StatusGlobalOVTexto']
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_STATUS_GLOBAL_OV', element: 'StatusGlobalOv' } } ]
          StatusGlobalOV,
          @Consumption.filter.hidden: true
          StatusGlobalOVTexto,
          @EndUserText.label: 'Nº do pedido'
          CorrespncExternalReference,
          @EndUserText.label: 'Liberação Comércio Exterior'
          StatusDeliveryBlockReasonComex,
          @Consumption.filter.hidden: true
          ColorStatusDeliveryBlockReason,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'Material'
          Material,
          @Consumption.filter.mandatory: true
          @EndUserText.label: 'Centro'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } } ]
          Plant,
          @EndUserText.label: 'Centro Depósito Fechado'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PlantStdVH', element: 'Plant' } } ]
          CentroDepFechado,
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DEPOSITO', element: 'Plant' }, additionalBinding: [{ element: 'Werks', localElement: 'Plant' }] } ]
          StorageLocation,
          @EndUserText.label: 'Itinerário'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_FAT_ITINERARIO', element: 'Route' } } ]
          Route,
          //          @ObjectModel.virtualElement: true
          //          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CKPT_FAT_VALMIN'
          @EndUserText.label: 'Valor Mínimo Atingido'
          ValorMin,
          @Consumption.filter.hidden: true
          ColorValorMin,
          @EndUserText.label: 'Data Agendamento Entrega'
          DataAgendamento,
          @EndUserText.label: 'Data planejada - Sincronismo'
          Sincronismo,
          @EndUserText.label: 'Data planejada - Aprovação Comercial'
          AprovacaoComercial,
          @EndUserText.label: 'Data planejada - Aprovação Crédito'
          AprovacaoCredito,
          @EndUserText.label: 'Data planejada - Envio Roteirização'
          EnvioRoteirizacao,
          @EndUserText.label: 'Data planejada - Criação Ordem de Frete'
          CriacaoOrdemFrete,
          @EndUserText.label: 'Data planejada - Faturamento'
          Faturamento,
          @EndUserText.label: 'Data planejada - Saída do Veículo'
          SaidaVeiculo,
          @EndUserText.label: 'Data planejada - Entrega'
          Entrega,
          @EndUserText.label: 'Data planejada - SLA Externo'
          SLAExterno,
          @EndUserText.label: 'Data planejada - SLA Interno'
          SLAInterno,
          @EndUserText.label: 'Data planejada - SLA Geral'
          SLAGeral,
          @EndUserText.label: 'Data planejada - Geração da remessa'
          GeracaoRemessa,
          @EndUserText.label: 'Data planejada - Estoque'
          Estoque,
          @EndUserText.label: 'Data planejada - Aprovação da NF-e'
          AprovacaoNFe,
          @EndUserText.label: 'Data planejada - Impressão da NF-e'
          ImpressaoNFe,
          @EndUserText.label: 'Data planejada - Prestação de contas'
          PrestacaoContas,
          @EndUserText.label: 'Data planejada - Carregamento'
          Carregamento,
          @EndUserText.label: 'Chave cliente K-Account'
          @ObjectModel.text.element: ['CodigoServicoTexto']
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_CUSTOMER_SERVICE', element: 'ServicoCliente' } } ]
          CodigoServico,
          CodigoServicoTexto,
          @EndUserText.label: 'Área Atendimento Cliente'
          @ObjectModel.text.element: ['AreaAtendimentoTexto']
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_AREA_ATENDIMENTO', element: 'AreaAtendimento' } } ]
          AreaAtendimento,
          @Consumption.filter.hidden: true
          AreaAtendimentoTexto,
          @EndUserText.label: 'Valor Mínimo Ov'
          ValorMinOv,
          @EndUserText.label: 'Valor Pendente Ov'
          VlrPendOV,
          @EndUserText.label: 'Pedido Auxiliar'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_PEDIDO_AUX', element: 'CorrespncExternalReference' } } ]
          PedidoAux,
          @EndUserText.label  : 'Prioridade de remessa'
          @ObjectModel.text.element: ['DeliveryPriorityDesc']
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_VH_SD_LPRIO', element: 'DeliveryPriority' } } ]
          DeliveryPriority,
          @EndUserText.label  : 'Denominação Prioridade de Remessa'
          @Consumption.filter.hidden: true
          @UI.hidden: true
          DeliveryPriorityDesc,


          _ZI_SalesDocumentQuickView
}
