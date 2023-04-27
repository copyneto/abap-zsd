@EndUserText.label: 'CDS Proj - Relatório de Status do Pedido'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_STATUS_PEDIDO
  as projection on ZI_SD_STATUS_PEDIDO
{
      @EndUserText.label: 'Cliente'
  key Sold_ToParty,
      @EndUserText.label: 'Ordem de Venda'
  key Sales_Order,
      @EndUserText.label: 'Remessa'
  key DocRemessa,
      @EndUserText.label: 'Ordem de Frete'
      OrdemFrete,
      @EndUserText.label: 'Org. de Vendas'
      @Consumption.filter.mandatory: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VKORG', element: 'OrgVendas' } }]
      Sales_Organization,
      @EndUserText.label: 'Canal de distribuição'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VTWEG', element: 'CanalDistrib' } }]
      Dist_Channel,
      @EndUserText.label: 'Esc. de vendas'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VKBUR', element: 'SalesOffice' } }]
      Sales_Office,
      @EndUserText.label: 'Região de vendas'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_BZIRK', element: 'RegiaoVendas' } }]
      Sales_District,
      @EndUserText.label: 'Referência do Cliente'
      Purchase_OrderCust,
      @EndUserText.label: 'Canal entrada pedido'
      Cust_PurchaseOrder,
      @EndUserText.label: 'Motivo da ordem'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_AUGRU', element: 'SDDocumentReason' } }]
      SD_DocReason,
      @EndUserText.label: 'Condição de Expedição'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VSBED', element: 'CondicaoExpedicao' } }]
      Shipping_Cond,
      @EndUserText.label: 'Tipo de ordem do cliente'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_AUART', element: 'SalesDocumentType' } }]
      Sales_OrderType,
      @EndUserText.label: 'Meio de pagto.'
      Cust_PaymentTerms,
      @Consumption.filter: { selectionType: #INTERVAL, multipleSelections: true }
      @EndUserText.label: 'Dt. Sirius'
      Cust_PurchaseOrderDate,
      //      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_DIAS', element: 'Nome' }}]
      @Consumption.filter: { selectionType: #INTERVAL, multipleSelections: true }
      @EndUserText.label: 'Dt. Criação da OV'
      @Consumption.filter.mandatory: true
      Creation_Date,
      @EndUserText.label: 'Número do Pedido'
      Purch_ShipToParty,      
      @EndUserText.label: 'Bloqueio de Remessa'      
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_LIFSK', element: 'DeliveryBlock' } }]
      Delivery_BlockReason,
      @EndUserText.label: 'Status da Ordem de Venda'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_GBSTK', element: 'Gbstk' } }]
      StatusOV,
      @EndUserText.label: 'Centro'
      @Consumption.filter.mandatory: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } }]
      Plant,
      @EndUserText.label: 'Local de Expedição'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VSTEL', element: 'LocalExpedicao' } }]
      Ship_Point,
      @EndUserText.label: 'Motivo de Recusa'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_ABGRU', element: 'SalesDocumentRjcnReason' } }]
      Sales_DocRjcnReason,
      @EndUserText.label: 'Desc. Motivo de Recusa'
      DescMotivoRecusa,
      @EndUserText.label: 'Categ. Remessa'
      SubsequentDocumentCategory,
      @Consumption.filter: { selectionType: #INTERVAL, multipleSelections: true }
      @EndUserText.label: 'Dt. Criação Ordem de Frete'
      CreationDate,
      @Consumption.filter: { selectionType: #INTERVAL, multipleSelections: true }
      @EndUserText.label: 'Dt. Faturamento'
      CreationDateFatura,
      @EndUserText.label: 'Nº da Fatura'
      FaturaDoc,
      @EndUserText.label: 'Nº Nota fiscal'
      BR_NFeNumber,
      @Consumption.filter: { selectionType: #INTERVAL, multipleSelections: true }
      @EndUserText.label: 'Dt. NFe'
      BR_NFAuthenticationDate,
      @EndUserText.label: 'Nº Doc Num'
      BR_NotaFiscal,
      @EndUserText.label: 'Valor da NFe'
      BR_NFNetAmount,
      @Consumption.filter: { selectionType: #INTERVAL, multipleSelections: true }
      @EndUserText.label: 'Data Docnum'
      BR_NFPostingDate,
      @EndUserText.label: 'Peso Líquido'
      HeaderNetWeight,
      @EndUserText.label: 'Peso Bruto'
      HeaderGrossWeight,
      @EndUserText.label: 'Peso Bruto - Unidade'
      HeaderWeightUnit,
      @EndUserText.label: 'Impressão'
      @Consumption.filter: { selectionType: #SINGLE }
      BR_NFIsPrinted,
      //      @EndUserText.label: 'CFOP'
      //      BR_CFOPCode,
      @Consumption.filter: { selectionType: #INTERVAL, multipleSelections: true }
      @EndUserText.label: 'Dt. criação Remessa'
      CreationDateRemessa,
      @EndUserText.label: 'Remessa'
      DeliveryDocument,
      @EndUserText.label: 'Desc. Condição de expedição'
      ShippingConditionName,
      @EndUserText.label: 'Vendedor Interno'
      VendedorInt,
      @EndUserText.label: 'Vendedor Externo'
      VendedorExt,
      //  @ObjectModel.virtualElement: true
      //  @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CONVERSION_STS_PARVW'
      //  PartnerFunction,
      @EndUserText.label: 'Descrição Cliente'
      CustomerPartnerDescription,
      @EndUserText.label: 'UF'
      Region,
      @EndUserText.label: 'Cidade'
      CityName,
      @EndUserText.label: 'Cat. Ordem de Frete'
      FaturaDocCat,
      @EndUserText.label: 'CEP'
      CEP,
      @EndUserText.label: 'Domicílio Fiscal'
      DomFiscal,
      @EndUserText.label: 'Motorista'
      Motorista,
      Matricula


}
