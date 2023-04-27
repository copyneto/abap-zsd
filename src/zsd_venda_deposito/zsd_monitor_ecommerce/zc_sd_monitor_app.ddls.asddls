@EndUserText.label: 'Monitor E-Commerce'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_MONITOR_APP
  as projection on ZI_SD_MONITOR_APP as Monitor
{
            @EndUserText.label: 'Ordem de cliente'
  key       SalesOrder,
            @EndUserText.label: 'Fornecimento'
  key       Remessa  as OutboundDelivery,
            @EndUserText.label: 'Fatura'
  key       Fatura   as BillingDocument,
            @EndUserText.label: 'NF-e'
  key       NfeNum,
            @EndUserText.label: 'Fornecimento'
            RemessaDisplay,
            @EndUserText.label: 'Fatura'
            FaturaDisplay,
            @EndUserText.label: 'NF-e'
            NfeNumDisplay,
            @EndUserText.label: 'Tipo da Ordem'
            SalesOrderType,
            @EndUserText.label: 'Emissor da ordem'
            Customer,
            @EndUserText.label: 'Nome do Emissor da ordem'
            CustomerName,
            @EndUserText.label: 'Número do pedido'
            PurchaseOrder,
            @EndUserText.label: 'Data Criação'
            CreationDate,
            @EndUserText.label: 'Canal de distribuição'
            DistributionChannel,
            @EndUserText.label: 'Hora da Criação'
            CreationTime,
            @EndUserText.label: 'Bloqueio da remessa'
            DeliveryBlockReason,
            @EndUserText.label: 'Status global'
            @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STAUSGLOBAL', element: 'Text' }}]
            Status,
            @EndUserText.label: 'Documento NF'
            NFDocnum as NotaFiscal,
            @EndUserText.label: 'Ordem de frete'
            FreightOrder, //OrdemFrete,
            @EndUserText.label: 'Unidade de frete'
            UnidadeFrete,
            @ObjectModel.text.element: ['PlantName']
            @EndUserText.label: 'Centro'
            Centro,
            @EndUserText.label: 'Região'
            Region,
            @EndUserText.label: 'Transportadora'
            Supplier,
            @EndUserText.label: 'Nome da transportadora'
            SupplierName,
            @EndUserText.label: 'Status impressão'
            @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_STATUSPRINT', element: 'Text' }}]
            StatusPrint,
            @EndUserText.label: 'Status NF-e'
            @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_STATUSNFE', element: 'Text' }}]
            StatusNfe,
            @EndUserText.label: 'Remessa em (Data/Hora)'
            DateTimeCreate,
            @EndUserText.label: 'Picking em (Data/Hora)'
            DateTimePicking,
            @EndUserText.label: 'Saída de mercadoria (Data/Hora)'
            DateTimeMovement,
            @EndUserText.label: 'Fatura (Data/Hora)'
            DateTimeCreateBilling,
            @EndUserText.label: 'Saída para entrega (Data/Hora)'
            ActualDateSaida,
            //ActualDate,
            StatusColor,
            StatusNfeColor,
            StatusPrintColor,
            BillingDocumentIsCancelled,
            //_Plant.PlantName
            PlantName,

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
  virtual   URL_vf03  : eso_longtext,
            @UI.hidden: true
            @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLSD_MONITOR_ECOMMERCE_URL' }
  virtual   URL_j1b3n : eso_longtext,
            @UI.hidden: true
            @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLSD_MONITOR_ECOMMERCE_URL' }
  virtual   URL_frete : eso_longtext

}
