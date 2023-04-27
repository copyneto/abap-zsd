@EndUserText.label: 'App Contratos Locação de Comodato'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_CONTR_LOC_COMODATO_APP
  as projection on ZI_SD_CONTR_LOC_COMODATO_APP
{
          @EndUserText.label: 'Documento de vendas/Contrato'
  key     SalesContract,
          @EndUserText.label: 'Item do Documento de Vendas'
          @Consumption.filter.hidden: true
  key     SalesContractItem,
          @EndUserText.label: 'Ordem de Venda'
          @Consumption.filter.hidden: true
  key     SalesOrder,
          @EndUserText.label: 'Local de Negócio'
          @ObjectModel.text.element: ['PlantName']
          @Consumption.valueHelpDefinition: [{entity: {name: 'I_PlantStdVH', element: 'Plant' }}]
          Plant,
          @EndUserText.label: 'Descrição Local de Negócio'
          PlantName,
          @EndUserText.label: 'Tipo de DV'
          @Consumption.filter.mandatory: true
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_AUART', element: 'SalesDocumentType' }}]
          SalesContractType,
          @EndUserText.label: 'Data da Criação'
          SalesContractDate,
          @EndUserText.label: 'Emissor da Ordem'
          @ObjectModel.text.element: ['CustomerName']
          Customer,
          @EndUserText.label: 'Descrição do Emissor da Ordem'
          @Consumption.filter.hidden: true
          CustomerName,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'Vendedor'
          @ObjectModel.text.element: ['PersonnelName']
          Personnel,
          @EndUserText.label: 'Descrição do Vendedor'
          @Consumption.filter.hidden: true
          PersonnelName,
          @EndUserText.label: 'Fornecedor'
          @ObjectModel.text.element: ['SupplierName']
          Supplier,
          @EndUserText.label: 'Descrição do Fornecedor'
          @Consumption.filter.hidden: true
          SupplierName,
          @EndUserText.label: 'Recebedor Mercadoria'
          @ObjectModel.text.element: ['ReceiverName']
          Receiver,
          @EndUserText.label: 'Descrição do Recebedor Mercadoria'
          @Consumption.filter.hidden: true
          ReceiverName,
          @EndUserText.label: 'Função Parceiro'
          @ObjectModel.text.element: ['PartnerFunctionName']
          PartnerFunction,
          @EndUserText.label: 'Descrição Função Parceiro'
          @Consumption.filter.hidden: true
          PartnerFunctionName,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'Doc de Faturamento'
          Invoice,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'NFE de Retorno (Entrada)'
          NotaFiscalEntrada,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'Data da NF de Entrada'
          CreationDateEntrada,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'NFe de Saída'
          NotaFiscal,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'Data da NF de Saída '
          CreationDate,
//          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_SERIE', element: 'Serie' }}]
          @EndUserText.label: 'Número de Série do Material'
          Serie,
          @EndUserText.label: 'Material'
          @ObjectModel.text.element: ['SalesContractItemText']
          Material,
          @EndUserText.label: 'Descrição Material'
          @Consumption.filter.hidden: true
          SalesContractItemText,
          @EndUserText.label: 'Unidade de Medida'
          @Consumption.filter.hidden: true
          OrderQuantityUnit,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'Quantidade do Contrato'
          OrderQuantity,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'Valor Líquido'
          NetAmount,
          @EndUserText.label: 'Moeda'
          @Consumption.filter.hidden: true
          TransactionCurrency,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'Valor do Aluguel'
          ConditionAmount,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'Valor do Aluguel'
          ValorAluguel,
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STATUS', element: 'Status' }}]
          @EndUserText.label: 'Status'
          Status,
          @Consumption.filter.hidden: true
          ColorStatus,
          @EndUserText.label: 'Número da Solicitação'
          @Consumption.filter.hidden: true
          PurchaseOrderByCustomer
}
