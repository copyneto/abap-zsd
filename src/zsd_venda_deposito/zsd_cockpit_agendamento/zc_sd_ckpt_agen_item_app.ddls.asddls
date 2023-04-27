@EndUserText.label: 'App Cockpit de Agendamento'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_CKPT_AGEN_ITEM_APP
  as projection on ZI_SD_CKPT_AGEN_ITEM_APP
  association [0..1] to ZI_SD_VH_VSTGA as _Mot on $projection.Motivo = _Mot.Motivo
{
          @Consumption.filter.hidden: true
          //         @Consumption.hidden: true
  key     ChaveOrdemRemessa,
          @Consumption.filter.hidden: true
  key     ChaveDinamica,
          @EndUserText.label: 'Item'
  key     SalesOrderItem,
          @EndUserText.label: 'Ordem do cliente'
          @Consumption.semanticObject: 'SalesDocument'
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_ORDEM', element: 'SalesOrder' }}]
          SalesOrder,
          @EndUserText.label: 'Remessa'
          Remessa,
          @Consumption.filter.hidden: true
          @Consumption.hidden: true
          Ordem_remessa,
          @Consumption.valueHelpDefinition: [ { entity:  { name:    'I_Customer_VH', element: 'Customer' } }]
          @EndUserText.label: 'Emissor da ordem'
          SoldToParty,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'Nome Emissor da ordem'
          SoldToPartyName,
          @EndUserText.label: 'Referência do cliente'
          @Consumption.valueHelpDefinition: [ { entity:  { name:    'ZI_CA_VH_REF_CLIENTE', element: 'Referencia' } }]
          PurchaseOrderByCustomer,
          @EndUserText.label: 'Data solicitada de remessa'
          RequestedDeliveryDate,
          @EndUserText.label: 'Data de criação do pedido'
          //         @Consumption.filter.mandatory: true
          CreationDate,
          @Consumption.filter.hidden: true
          SalesOrganization,
          //         @Consumption.filter.hidden: true
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VTWEG', element: 'CanalDistrib' } } ]
          DistributionChannel,
          @Consumption.filter.hidden: true
          OrganizationDivision,
          //         @Consumption.filter.hidden: true
          @EndUserText.label: 'Paletização'
          //       CustomerAccountAssignmentGroup,
          //         cast( PalletItem as ze_paletizacao  preserving type ) as PalletItem,
          PalletItem,
          @EndUserText.label: 'Pallet Fracionado'
          PalletFracionado,
          @Consumption.filter.hidden: true
          @Consumption.hidden: true
          SalesOrderI,
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_WERKS', element: 'WerksCode' }}]
          //         @Consumption.filter.mandatory: true
          @EndUserText.label: 'Centro'
          Plant,
          @EndUserText.label: 'Peso bruto'
          @Consumption.filter.hidden: true
          ItemGrossWeight,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'Peso líquido'
          ItemNetWeight,
          @Consumption.filter.hidden: true
          ItemWeightUnit,
          @EndUserText.label: 'Material'
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_MATERIAL', element: 'Material' }}]
          Material,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'Descrição produto'
          SalesOrderItemText,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'Volumes'
          ItemVolume,
          @EndUserText.label: 'Unidade de Volume'
          @Consumption.filter.hidden: true
          ItemVolumeUnit,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'Unidade de medida'
          OrderQuantityUnit,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'Quantidade do Item'
          OrderQuantity,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'Status Recusa'
          SalesDocumentRjcnReason,
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_CKPT_AGEN_VH_STATUS_OV', element: 'Texto' }}]
          @EndUserText.label: 'Status da Ordem'
          OverallSDProcessStatus,
          @Consumption.filter.hidden: true
          OverallSDProcessStatusColor,
          @EndUserText.label: 'Tipo ordem'
          SalesOrderType,
          @EndUserText.label: 'Região de vendas'
          SalesDistrict,
          @EndUserText.label: 'Itinerario'
          @Consumption.valueHelpDefinition: [{entity: {name: 'I_TripRouteVH', element: 'ShippingRoute' }}]
          Route,
          @EndUserText.label: 'Data criação do pedido (SIRIUS)'
          CustomerPurchaseOrderDate,
          @EndUserText.label: 'Vendedor'
          Supplier,
          @EndUserText.label: 'Grupo de Agendamento'
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_KVGR5', element: 'Agrupamento' }}]
          @ObjectModel.text: { element: ['AgrupametoText'] }
          kvgr5,
          AgrupametoText,
          @Consumption.filter.hidden: true
          regio,
          @Consumption.filter.hidden: true
          ort01,
          @Consumption.filter.hidden: true
          ort02,
          @Consumption.filter.hidden: true
          @Consumption.hidden: true
          Document,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'DocNum NF-e'
          DocNum,
          @EndUserText.label: 'Total NF-e'
          @Consumption.filter.hidden: true
          @UI.hidden: true
          Total_Nfe,
          @Consumption.filter.hidden: true
          Currency,
          @EndUserText.label: 'Nota Fiscal'
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_DOCNUM', element: 'BR_NFeNumber' }}]
          NotaFiscal,
          @EndUserText.label: 'Ordem de frete'
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_OF', element: 'OrdemFrete' }}]
          OrdemFrete,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'Unidade de Frete'
          UnidadeFrete,
          //         @Consumption.filter.hidden: true
          //         @EndUserText.label: 'Data de entrega'
          //         DataEntrega,
          //         @Consumption.filter.hidden: true
          @EndUserText.label: 'Data de entrega'
          //         @Consumption.hidden: true
          DataEntregaConv,
          @EndUserText.label: 'Data agendada'
          DataAgendada,
          @EndUserText.label: 'Hora agendada'
          HoraAgendada,
          //         @Consumption.filter.hidden: true
          //         @UI.hidden: true
          //         @EndUserText.label: 'Motivo Agenda'
          //         MotivoAgenda,
          @EndUserText.label: 'Motivo Agenda'
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_VSTGA', element: 'Motivo' }}]
          Motivo,
          @EndUserText.label: 'Descrição Motivo Agenda'
          MotivoText,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'Observações'
          Observacoes,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'Senha Cliente'
          Senha,
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_ESTADO', element: 'Valor' }}]
          @ObjectModel.text: { element: ['StatusText'] }
          Status,
          @UI.hidden: true
          StatusText,
          @Consumption.filter.hidden: true
          StatusColor,
          @Consumption.filter.hidden: true
          @Consumption.hidden: true
          Salesorder_conv,
          @EndUserText.label: 'Status de Remessa Item'
          DeliveryStatus,
          /* Associations */


          _Cliente,
          _Grupo,
          _Item,
          _Partner,
          //          _Remessa,
          @Consumption.filter.hidden: true
          _Mot,
          @Semantics.amount.currencyCode:'Currency'
          @EndUserText.label: 'Total NF-e'
          @Consumption.filter.hidden: true
          @ObjectModel:  {virtualElement: true, virtualElementCalculatedBy: 'ZCLSD_CKPT_AGEND_CONV'}
  virtual total : j_1bnfnett
}
