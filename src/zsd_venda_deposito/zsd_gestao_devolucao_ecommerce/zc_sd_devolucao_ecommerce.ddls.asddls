@EndUserText.label: 'Gestão das devoluções e-commerce'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_DEVOLUCAO_ECOMMERCE
  as projection on ZI_SD_ECOMMERCE as ECOMMERCE

{
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_ORDEM_CLIENTE', element: 'OrdCliente' }}]
          @EndUserText.label: 'Ordem do cliente '
  key     SalesOrder as OrdemCliente,
          @EndUserText.label: 'Ordem devolução '
  key     Ordem      as SalesOrder,
          @EndUserText.label: 'Fornecimento'
  key     Remessa    as OutboundDelivery,
          @EndUserText.label: 'Fatura devolução '
  key     FaturaDev  as BillingDocument,
          @EndUserText.label: 'Remessa Venda'
  key     RemVend,  
          @EndUserText.label: 'Fatura venda'
  key     FaturaVend,  
          @EndUserText.label: 'NF-e devolução '
          NFDevolucao,
          @EndUserText.label: 'Número do Pedido '
          PurchaseOrderByCustomer,
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_DISTRIBUTIONCHANNEL', element: 'OrgUnidID' }}]
          @EndUserText.label: 'Canal de distribuição '
          DistributionChannel,
          @EndUserText.label: 'NF-e Venda '
          BR_NFeNumber,
          //@Consumption.valueHelpDefinition: [{entity: {name: 'I_Plant', element: 'Plant' }}]
          @ObjectModel.text.element: ['PlantName']
          @Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_SD_VH_WERKS_PAR', element: 'WerksCode'  } }]
          @EndUserText.label: 'Centro'
          @Consumption.filter:{ mandatory:true }
          ShippingPoint,
          @EndUserText.label: 'Etapa do processo '
          Processo,
          EtapaProcesso,
          @EndUserText.label: 'Status processo'
          StatusColor,
          @EndUserText.label: 'Ticket SAC '
          CorrespncExternalReference,
          @EndUserText.label: 'Data/Hora Criação OV'
          DateTimeCreate,
          @EndUserText.label: 'Cliente'
          Customer,
          @EndUserText.label: 'Nome'
          Name1,
          SalesDocumentCurrency,
          @EndUserText.label: 'Região'
          BR_NFPartnerRegionCode,
          @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
          @EndUserText.label: 'Valor total'
          BR_NFTotalAmount,
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_STATUSNFE', element: 'Text' }}]
          @EndUserText.label: 'Status NF-e Devolução'
          StatusNfeDevolucao,
          @EndUserText.label: 'Data da devolução'
          CreationDate,
          @EndUserText.label: 'Hora devolução '
          CreationTime,
          @EndUserText.label: 'Data de criação'
          CreationDateCli,
          StatusNfeDevolucaoColor,
          _Plant.PlantName,
          
            @UI.hidden: true
            @ObjectModel: { virtualElement: true,
                      virtualElementCalculatedBy: 'ABAP:ZCLSD_MONITOR_ECOMMERCE_URL' }
  virtual   URL_va03  : eso_longtext,
            @UI.hidden: true
            @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLSD_MONITOR_ECOMMERCE_URL' }
  virtual   URL_vl03n : eso_longtext,
            @UI.hidden: true
            @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLSD_MONITOR_ECOMMERCE_URL' }
  virtual   URL_vf03  : eso_longtext
  
}
