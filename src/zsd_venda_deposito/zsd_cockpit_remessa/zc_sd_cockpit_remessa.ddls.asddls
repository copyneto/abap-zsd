@EndUserText.label: 'Cockpit gerenciamento de remessas'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

@ObjectModel.semanticKey: ['SalesDocument' ]

define root view entity ZC_SD_COCKPIT_REMESSA
  as projection on ZI_SD_COCKPIT_REMESSA
{
          @EndUserText.label: 'Ordem de Venda'
  key     SalesDocument,
          @EndUserText.label: 'Remessa'
  key     OutboundDelivery,
//          @EndUserText.label: 'Vendedor Interno'
//          //      @ObjectModel.text.element: ['VendorIntName']
//          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_LIFNR', element: 'LifnrCode' } } ]
//          VendorInt,
//          @EndUserText.label: 'Nome Vendedor Interno'
//          VendorIntName,
//          @EndUserText.label: 'Vendedor Externo'
//          //      @ObjectModel.text.element: ['VendorExtName']
//          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_LIFNR', element: 'LifnrCode' } } ]
//          VendorExt,
//          @EndUserText.label: 'Nome Vendedor Externo'
//          VendorExtName,
//          @EndUserText.label: 'Tipo Ordem de Venda'
//          @ObjectModel.text.element: ['SalesOrderTypeName']
//          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_AUART', element: 'SalesDocumentType' } } ]
//          SalesOrderType,
//          SalesOrderTypeName,
//          @EndUserText.label: 'Data desejada Remessa'
//          RequestedDeliveryDate,
//          @EndUserText.label: 'Emissor da Ordem'
//          //      @ObjectModel.text.element: ['SoldToPartyName']
//          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_KUNNR', element: 'Kunnr' } } ]
//          SoldToParty,
//          @EndUserText.label: 'Nome Emissor da Ordem'
//          SoldToPartyName,
//          @EndUserText.label: 'Bloqueio de Remessa'
//          @ObjectModel.text.element: ['DeliveryBlockReasonText']
//          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_LIFSK', element: 'DeliveryBlock' } } ]
//          DeliveryBlockReason,
//          DeliveryBlockReasonText,
//          @EndUserText.label: 'Data criação OV'
//          SalesCreationDate,
//          @EndUserText.label: 'Hora criação OV'
//          SalesCreationTime,
//          @Consumption.filter.mandatory: true
//          @EndUserText.label: 'Centro'
//          @ObjectModel.text.element: ['PlantName']
//          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } } ]
//          Plant,
//          PlantName,
//          @EndUserText.label: 'Valor Total'
//          TotalNetAmount,
//          @EndUserText.label: 'Moeda'
//          TransactionCurrency,
//          @EndUserText.label: 'Ordem de Frete'
//          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_REMESSA_OF', element: 'TransportationOrder' } } ]
////          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_ORDEM_FRETE', element: 'TransportationOrder' } } ]
//          FreightOrder,
//          @EndUserText.label: 'Data Hora Criação Ordem de Frete'
//          @Consumption.filter.hidden: true
//          CreatedOn,
//          @EndUserText.label: 'Data Criação Ordem de Frete'
//          CreatedOnDat,
//          @EndUserText.label: 'Saída de Mercadoria'
//          @ObjectModel.text.element: ['OverallGoodsMovementStatusDesc']
//          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_WBSTK', element: 'OverallGoodsMovementStatus' } } ]
//          OverallGoodsMovementStatus,
//          OverallGoodsMovementStatusDesc,
//          @EndUserText.label: 'Fatura'
//          BillingDocument,
//          @EndUserText.label: 'Status Contábil'
//          @ObjectModel.text.element: ['AccountingPostingStatusDesc']
//          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_BUCHK', element: 'AccountingPostingStatus' } } ]
//          AccountingPostingStatus,
//          AccountingPostingStatusDesc,
//          @EndUserText.label: 'Data criação Fatura'
//          BillingDocumentDate,
//          @EndUserText.label: 'Categoria Faturamento'
//          @ObjectModel.text.element: ['BillingDocumentCategoryName']
//          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_FKTYP', element: 'BillingDocumentCategory' } } ]
//          BillingDocumentCategory,
//          BillingDocumentCategoryName,
//          @EndUserText.label: 'Tipo Faturamento'
//          @ObjectModel.text.element: ['BillingDocumentTypeName']
//          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_FKART', element: 'BillingDocumentType' } } ]
//          BillingDocumentType,
//          BillingDocumentTypeName,
//          //      @EndUserText.label: 'Tipo Ordem Venda'
//          //      @ObjectModel.text.element: ['SalesDocumentTypeName']
//          //      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_AUART', element: 'SalesDocumentType' } } ]
//          //      SalesDocumentType,
//          //      SalesDocumentTypeName,
//          @EndUserText.label: 'Canal de Distribuição'
//          @ObjectModel.text.element: ['DistributionChannelName']
//          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VTWEG', element: 'CanalDistrib' } } ]
//          DistributionChannel,
//          DistributionChannelName,
//          @EndUserText.label: 'Escritório de vendas'
//          @ObjectModel.text.element: ['SalesOfficeName']
//          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VKBUR', element: 'SalesOffice' } } ]
//          SalesOffice,
//          SalesOfficeName,
//          @EndUserText.label: 'Equipe de vendas'
//          @ObjectModel.text.element: ['SalesGroupName']
//          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VKGRP', element: 'SalesGroup' } } ]
//          SalesGroup,
//          SalesGroupName,
//          @EndUserText.label: 'Data criação pedido SIRIUS'
//          CustomerPurchaseOrderDate,
//          @EndUserText.label: 'Data criação Remessa'
//          DeliveryCreationDate,
//          @EndUserText.label: 'Hora criação Remessa'
//          DeliveryCreationTime,
//          @EndUserText.label: 'Peso Bruto'
//          ItemGrossWeightAvailable,
//          //      @EndUserText.label: 'Peso Bruto Total'
//          //      ItemGrossWeightTotal,
//          //      @EndUserText.label: 'Peso Bruto (%)'
//          //      ItemGrossWeightPerc,
//          ItemGrossWeightPercCrit,
//          @EndUserText.label: 'Agendamento'
//          @ObjectModel.text.element: ['AdditionalCustomerGroup5Name']
//          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_KVGR5_NEW', element: 'AdditionalCustomerGroup5' } } ]
//          AdditionalCustomerGroup5,
//          AdditionalCustomerGroup5Name,
//          @EndUserText.label: 'Status atendimento OV'
//          @ObjectModel.text.element: ['OverallDeliveryStatusDesc']
//          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_LFSTK', element: 'OverallDeliveryStatus' } } ]
//          OverallDeliveryStatus,
//          OverallDeliveryStatusDesc,
//
//          @EndUserText.label: 'Número Nota Fiscal'
//          BR_NotaFiscal,
//          @EndUserText.label: 'Nº Documento'
//          NotaFiscal,
//          @EndUserText.label: 'Tipo Nota Fiscal'
//          @ObjectModel.text.element: ['BR_NFTypeName']
//          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_NFTYPE', element: 'BR_NFType' } } ]
//          BR_NFType,
//          _NFType.BR_NFTypeName as BR_NFTypeName,
//          @EndUserText.label: 'Tipo de documento'
//          @ObjectModel.text.element: ['BR_NFDocumentTypeName']
//          //      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DOCTYP_NF', element: 'BR_NFDocumentType' } } ]
//          @Consumption.filter.hidden: true
//          BR_NFDocumentType,
//          _NFDocumentType.Text  as BR_NFDocumentTypeName,
//          @EndUserText.label: 'Direção de movimento'
//          @ObjectModel.text.element: ['BR_NFDirectionDesc']
//          @Consumption.filter.hidden: true
//          BR_NFDirection,
//          BR_NFDirectionDesc,
//          @EndUserText.label: 'Modelo'
//          @ObjectModel.text.element: ['BR_NFModelDesc']
//          @Consumption.filter.hidden: true
//          BR_NFModel,
//          BR_NFModelDesc,
//          @EndUserText.label: 'Data criação Nota Fiscal'
//          NFCreationDate,
//          @EndUserText.label: 'Hora criação Nota Fiscal'
//          NFCreationTime,
//          @EndUserText.label: 'Região de Vendas'
//          //          @ObjectModel.text.element: ['SalesDistrictName']
//          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_BZIRK', element: 'RegiaoVendas' } } ]
//          //          @Consumption.filter.hidden: true
//          SalesDistrict,
//          @Consumption.filter.hidden: true
//          SalesDistrictName,
//          /* Abstract */
//          @EndUserText.label  : 'Bloqueio remessa'
//          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_REMESSA_BLOQUEIO', element: 'DeliveryBlockReason' } } ]
//          DeliveryBlockReasonNew,
//          @EndUserText.label  : 'Prioridade de remessa'
//          //          @ObjectModel.text.element: ['DeliveryPriorityDesc']
//          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_VH_SD_LPRIO', element: 'DeliveryPriority' } } ]
//          DeliveryPriority,
//          @EndUserText.label  : 'Denominação Prioridade de Remessa'
//          @Consumption.filter.hidden: true
//          DeliveryPriorityDesc,
//          @EndUserText.label: 'Itinerário'
//          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_FAT_ITINERARIO', element: 'Route' } } ]
//          Route,
//          @EndUserText.label  : 'Código de status da NF-e'
//          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_STATUSNFE', element: 'Text' }}]
//          BR_NFeDocumentStatus,
//          ColorBR_NFeDocumentStatus,
//          @EndUserText.label  : 'Evento da Ordem de Frete'
//          EventCode,
//          @EndUserText.label  : 'NF-e impressa'
//          //          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_STATUSPRINT', element: 'Text' }}]
//          BR_NFIsPrinted,
//
//          @EndUserText.label  : 'Criticalidade'
//          Criticality,
//
//          @Consumption.valueHelpDefinition: [{entity: {name: 'I_OverallPickingStatus', element: 'OverallPickingStatus' }}]
//          @ObjectModel.text.element: ['PickingStatusText']
//          @EndUserText.label  : 'Status Picking'
//          OverallPickingStatus,
//          @UI.hidden: true
//          PickingStatusText,
//          @UI.hidden: true
//          PickingStatusColor,
//
//          @EndUserText.label  : 'Log'
//          Message,

          @UI.hidden: true
          @ObjectModel: { virtualElement: true,
                    virtualElementCalculatedBy: 'ABAP:ZCLSD_COCKPIT_REMESSA_URL' }
  virtual URL_va03  : eso_longtext,
          @UI.hidden: true
          @ObjectModel: { virtualElement: true,
                        virtualElementCalculatedBy: 'ABAP:ZCLSD_COCKPIT_REMESSA_URL' }
  virtual URL_vl03n : eso_longtext,
          @UI.hidden: true
          @ObjectModel: { virtualElement: true,
                        virtualElementCalculatedBy: 'ABAP:ZCLSD_COCKPIT_REMESSA_URL' }
  virtual URL_vf03  : eso_longtext,
          @UI.hidden: true
          @ObjectModel: { virtualElement: true,
                        virtualElementCalculatedBy: 'ABAP:ZCLSD_COCKPIT_REMESSA_URL' }
  virtual URL_j1b3n : eso_longtext,
          @UI.hidden: true
          @ObjectModel: { virtualElement: true,
                        virtualElementCalculatedBy: 'ABAP:ZCLSD_COCKPIT_REMESSA_URL' }
  virtual URL_frete : eso_longtext,

          /* Associations */
          _CockpitLog : redirected to composition child ZC_SD_COCKPIT_REMESSA_LOG
}
