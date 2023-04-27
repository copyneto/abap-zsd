@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Relatório de remessa'
@Metadata.allowExtensions: true
@VDM.viewType: #CONSUMPTION

define root view entity ZC_SD_RELATORIO_REMESSA
  as projection on ZI_SD_RELATORIO_REMESSA
{


      @UI: { lineItem:       [ { position: 10, importance: #HIGH } ],
             selectionField: [ { position: 30 } ] }
      @EndUserText.label: 'Ordem de venda'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_SalesOrderStdVH', element: 'SalesOrder' } }]
  key SalesOrderDocument,

      @UI: { lineItem:       [ { position: 20, importance: #HIGH } ] }
      @EndUserText.label: 'Item OV'
  key SalesOrderDocumentItem,

      @UI: { lineItem:       [ { position: 70, importance: #HIGH } ],
             selectionField: [ { position: 260 } ] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_DELIVERYDOCUMENTSTDVH', element: 'DeliveryDocument' } }]
  key DeliveryDocument,

      @UI: { lineItem:       [ { position: 30, importance: #HIGH } ],
             selectionField: [ { position: 230 } ] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_REGIO_BR', element: 'Region' } }]
      @EndUserText.label: 'UF'
      CustomerRegion,

      @UI: { lineItem:       [ { position: 40, importance: #HIGH } ],
             selectionField: [ { position: 140 } ] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VKORG', element: 'OrgVendas' } }]
      @Consumption.filter.mandatory: true
      SalesOrganization,

      @UI: { lineItem:       [ { position: 50, importance: #HIGH } ],
             selectionField: [ { position: 150 } ] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PlantStdVH', element: 'Plant' } }]
      @EndUserText.label: 'Centro faturamento'
      Plant,

      @UI: { lineItem:       [ { position: 60, importance: #HIGH } ],
             selectionField: [ { position: 170 } ] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_SalesOffice', element: 'SalesOffice' } }]
      SalesOffice,
      
      @UI: { lineItem:       [ { position: 80, importance: #HIGH } ],
             selectionField: [ { position: 10 } ] }
      @EndUserText.label: 'Cliente'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Customer_VH', element: 'Customer' } }]
      Customer,

      @UI: { lineItem:       [ { position: 81, importance: #HIGH } ] }
      @EndUserText.label: 'Descrição Cliente'
      CustomerName,

      @UI: { lineItem:       [ { position: 90, importance: #HIGH } ],
             selectionField: [ { position: 20 } ] }
      //      @ObjectModel.text.element: ['MaterialName']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_MaterialStdVH', element: 'Material' } }]
      Material,

      @UI: { lineItem:       [ { position: 91, importance: #HIGH } ] }
      @EndUserText.label: 'Descrição Material'
      MaterialName,

      @UI: { lineItem:       [ { position: 100, importance: #HIGH } ] }
      @EndUserText.label: 'Família'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ProductHierarchyNode', element: 'ProductHierarchyNode' } }]
      ProductFamily,

      @UI: { lineItem:       [ { position: 110, importance: #HIGH } ],
             selectionField: [ { position: 160 } ] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VTWEG', element: 'CanalDistrib' } }]
      DistributionChannel,

      @UI: { lineItem:       [ { position: 120, importance: #HIGH } ] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ShippingCondition', element: 'ShippingCondition' } }]
      ShippingCondition,

      @UI: { lineItem:       [ { position: 121, importance: #HIGH } ] }
      _ShippingConditionText.ShippingConditionName,

      @UI: { lineItem:       [ { position: 130, importance: #HIGH } ] }
      ShippingPoint,

      @UI: { lineItem:       [ { position: 140, importance: #HIGH } ],
             selectionField: [ { position: 80 } ] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_AUART', element: 'SalesDocumentType' } }]
      SalesDocumentType,

      @UI: { lineItem:       [ { position: 150, importance: #HIGH } ] }
      @EndUserText.label: 'Cidade'
      CustomerCityName,

      @UI: { lineItem:       [ { position: 160, importance: #HIGH } ],
             selectionField: [ { position: 200 } ] }
      @EndUserText.label: 'Referencia do Cliente' //'Nº Pedido Sirius'
      PurchaseDocument,

      @UI: { lineItem:       [ { position: 170, importance: #HIGH } ] }
      @EndUserText.label: 'Forma de pagamento'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_FORMA_PAGTO_FILTER', element: 'FormaPagtoId' } }]
      PaymentMethod,

      @UI: { lineItem:       [ { position: 180, importance: #HIGH } ] }
      @EndUserText.label: 'Data Sirius'
      SiriusDate,

      @UI: { lineItem:       [ { position: 190, importance: #HIGH } ],
             selectionField: [ { position: 100 } ] }
      @EndUserText.label: 'Dt. criação ordem de venda'
      @Consumption.filter.mandatory: true
      SalesOrderDate,

      @UI: { lineItem:       [ { position: 200, importance: #HIGH } ] }
      OrderQuantity,

      @UI: { lineItem:       [ { position: 210, importance: #HIGH } ] }
      OrderQuantityUnit,

      @UI: { lineItem:       [ { position: 220, importance: #HIGH, requiresContext: true } ],
             selectionField: [ { position: 50 } ] }
      @EndUserText.label: 'Dt. Remessa'
      DeliveryDocumentDate,

      @UI: { lineItem:       [ { position: 230, importance: #HIGH } ] }
      @EndUserText.label: 'Preço de tabela'
      CreditRelatedPrice,

      @UI: { lineItem:       [ { position: 240, importance: #HIGH } ] }
      @EndUserText.label: 'Cliente UNOP'
      CustomerUNOP,

      @UI: { lineItem:       [ { position: 241, importance: #HIGH } ] }
      @EndUserText.label: 'Desc. Cliente UNOP'
      CustomerUNOPName,

      @UI: { lineItem:       [ { position: 250, importance: #HIGH } ] }
      @EndUserText.label: 'Valor da NFe'
      NFNetAmount,

      @UI: { lineItem:       [ { position: 260, importance: #HIGH } ] }
      @EndUserText.label: 'Preço de Venda'
      SalesOrderNetAmount,

      @UI: { lineItem:       [ { position: 270, importance: #HIGH } ] }
      MaterialDocument,

      @UI: { lineItem:       [ { position: 280, importance: #HIGH } ],
             selectionField: [ { position: 110 } ] }
      @EndUserText.label: 'Data faturamento'
      CreationDate,

      @UI: { lineItem:       [ { position: 290, importance: #HIGH } ] }
      BillingDocument,

      @UI: { lineItem:       [ { position: 300, importance: #HIGH } ] }
      @EndUserText.label: 'Data autorização NF'
      NFAuthenticationDate,

      @UI: { lineItem:       [ { position: 310, importance: #HIGH } ] }
      @EndUserText.label: 'Valor do Custo'
      CostAmount,

      @UI: { lineItem:       [ { position: 320, importance: #HIGH } ] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_MaterialGroup', element: 'MaterialGroup' } }]
      MaterialGroup,

      @UI: { lineItem:       [ { position: 330, importance: #HIGH } ] }
      @EndUserText.label: 'Área de Atendimento'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_AREA_ATENDIMENTO', element: 'AreaAtendimento' } }]
      CustomerAreaAtendimento,

      @UI: { lineItem:       [ { position: 340, importance: #HIGH } ],
             selectionField: [ { position: 120 } ] }
      @EndUserText.label: 'Nº NFe'
      NFeNumber,

      @UI: { lineItem:       [ { position: 350, importance: #HIGH } ],
             selectionField: [ { position: 40 } ] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_LGORT', element: 'StorageLocation' } }]
      StorageLocation,

      @UI: { lineItem:       [ { position: 360, importance: #HIGH } ],
             selectionField: [ { position: 250 } ] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TM_VH_CFOP', element: 'cfop' } }]
      @EndUserText.label: 'CFOP'
      CFOPCode,

      @UI: { lineItem:       [ { position: 370, importance: #HIGH } ],
             selectionField: [ { position: 130 } ] }
      @EndUserText.label: 'Docnum'
      NotaFiscal,

      @UI: { lineItem:       [ { position: 380, importance: #HIGH } ] }
      @EndUserText.label: 'Data nota fiscal'
      NFPostingDate,

      @UI: { lineItem:       [ { position: 390, importance: #HIGH } ],
             selectionField: [ { position: 60 } ] }
      @EndUserText.label: 'Ordem de frete'
      TransportationOrder,

      @UI: { lineItem:       [ { position: 400, importance: #HIGH } ],
             selectionField: [ { position: 70 } ] }
      @EndUserText.label: 'Dt. ordem de frete'
      CreatedOn,

      @UI: { lineItem:       [ { position: 410, importance: #HIGH } ] }
      @EndUserText.label: 'Motorista'
      Motorista,

      @UI: { lineItem:       [ { position: 411, importance: #HIGH } ] }
      @EndUserText.label: 'Nome motorista'
      NomeMotorista,

      @UI: { lineItem:       [ { position: 420, importance: #HIGH } ],
             selectionField: [ { position: 210 } ] }
      //      @ObjectModel.text.element: ['SellerName']
      @EndUserText.label: 'Vendedor'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Supplier_VH', element: 'Supplier' } }]
      Seller,

      @UI: { lineItem:       [ { position: 421, importance: #HIGH } ] }
      @EndUserText.label: 'Nome Vendedor'
      SellerName,

      @UI: { lineItem:       [ { position: 430, importance: #HIGH } ] }
      ItemNetWeight,

      @UI: { lineItem:       [ { position: 440, importance: #HIGH } ] }
      ItemGrossWeight,

      @UI: { hidden: true }
      ItemWeightUnit,

      @UI: { lineItem:       [ { position: 450, importance: #HIGH } ] }
      @EndUserText.label: 'Impressão NF'
      NFIsPrinted,

      @UI: { lineItem:       [ { position: 460, importance: #HIGH } ],
             selectionField: [ { position: 190 } ] }
      @EndUserText.label: 'Numero do pedido' //'Nº Pedido Cliente'
      PurchaseOrderByShipToParty,

      @UI: { lineItem:       [ { position: 470, importance: #HIGH } ] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_REMESSA_BLOQUEIO', element: 'DeliveryBlockReason' } }]
      DeliveryBlockReason,

      @UI: { lineItem:       [ { position: 480, importance: #HIGH } ] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_SalesDocumentRjcnReason', element: 'SalesDocumentRjcnReason' } }]
      SalesDocumentRjcnReason,

      @UI: { lineItem:       [ { position: 481, importance: #HIGH } ] }
      _SalesDocumentRjcnReasonText.SalesDocumentRjcnReasonName,

      @UI: { lineItem:       [ { position: 490, importance: #HIGH } ] }
      @EndUserText.label: 'Agente de frete'
      FreightAgent,

      @UI: { lineItem:       [ { position: 491, importance: #HIGH } ] }
      @EndUserText.label: 'Nome agente de frete'
      FreightAgentName,

      @UI: { lineItem:       [ { position: 500, importance: #HIGH } ] }
      SalesOrderCreatedByUser,

      @UI: { lineItem:       [ { position: 510, importance: #HIGH } ] }
      @EndUserText.label: 'Placa'
      PlacaVeiculo,

      @UI: { lineItem:       [ { position: 520, importance: #HIGH } ] }
      @EndUserText.label: 'Peso Total'
      HeaderGrossWeight,

      @UI: { lineItem:       [ { position: 530, importance: #HIGH } ] }
      CustomerDistrict,

      @UI: { lineItem:       [ { position: 540, importance: #HIGH } ] }
      Batch,

      @UI: { lineItem:       [ { position: 550, importance: #HIGH } ] }
      @EndUserText.label: 'Vlr. Unitário'
      NetPriceAmount,

      @UI: { lineItem:       [ { position: 560, importance: #HIGH } ] }
      @EndUserText.label: 'Vlr. Total Item'
      NetAmount,

      @UI: { lineItem:       [ { position: 570, importance: #HIGH } ] }
      @EndUserText.label: 'Matricula'
      Matricula,

      @UI: { lineItem:       [ { position: 580, importance: #HIGH } ] }
      @EndUserText.label: 'Elemento PEP'
      WBSElement,

      @UI: { lineItem:       [ { position: 590, importance: #HIGH } ] }
      @EndUserText.label: 'Centro de custo'
      CostElement,

      //      @UI: { lineItem:       [ { position: 590, importance: #HIGH } ] }
      //      @EndUserText.label: 'Evento'
      //      EventName,

      @UI: { selectionField: [ { position: 90 } ] }
      @EndUserText.label: 'Status da ordem de venda'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_OverallSDProcessStatus', element: 'OverallSDProcessStatus' } }]
      OverallSDProcessStatus,

      @UI: { selectionField: [ { position: 90 } ] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_BZIRK', element: 'RegiaoVendas' } }]
      SalesDistrict,

      @UI: { selectionField: [ { position: 90 } ] }
      @EndUserText.label: 'Canal entrada pedido'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CustomerPurchaseOrderType', element: 'CustomerPurchaseOrderType' } }]
      CustomerPurchaseOrderType,

      @UI: { hidden: true }
      TransactionCurrency,

      @UI: { hidden: true }
      SalesDocumentCurrency,

      @UI: { hidden: true }
      HeaderWeightUnit,
      
      @UI: { lineItem:       [ { position: 600, importance: #HIGH } ] }
      @EndUserText.label: 'Quantidade da remessa'
      //@UI.textArrangement: #TEXT_SEPARATE
      @ObjectModel.text.element: ['DeliveryQuantityUnit']
      ActualDeliveryQuantity,
      
      @UI: { lineItem:       [ { position: 610, importance: #HIGH } ] }
      @EndUserText.label: 'UN medida remessa'    
      DeliveryQuantityUnit,


      /* Associations */
      _DeliveryDocument,
      _FreightAgent,
      _ShippingConditionText,
      _ProductHierarchyNodeText,
      _SalesDocumentTypeText,
      _DeliveryBlockReasonText,
      _SalesDocumentRjcnReasonText,
      _MaterialGroupText,
      _CustomerUNOP,
      _SalesDocument

}
