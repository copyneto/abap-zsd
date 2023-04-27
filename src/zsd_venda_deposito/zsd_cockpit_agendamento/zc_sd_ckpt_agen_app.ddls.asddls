@EndUserText.label: 'App Cockpit de Agendamento'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_CKPT_AGEN_APP
  //  as projection on ZI_SD_CKPT_AGEN_APP
  as projection on ZI_SD_CKPT_AGEND_UNION_APP
  //  association [0..1] to ZI_SD_VH_VSTGA as _Mot on $projection.Motivo = _Mot.Motivo
{
               @Consumption.filter.hidden: true
               //         @Consumption.hidden: true
  key          ChaveOrdemRemessa,
               @Consumption.filter.hidden: true
  key          ChaveDinamica,
               @EndUserText.label: 'Ordem do cliente'
               @Consumption.semanticObject: 'SalesDocument'
               @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_ORDEM', element: 'SalesOrder' }}]
  key          SalesOrder,
               @Consumption.filter.hidden: true
  key          SalesOrderItem,
               @EndUserText.label: 'Remessa'
  key          Remessa,
               @Consumption.filter.hidden: true
               //               @Consumption.hidden: true
  key          Ordem_remessa,
               @Consumption.valueHelpDefinition: [ { entity:  { name:    'I_Customer_VH', element: 'Customer' } }]
               @EndUserText.label: 'Emissor da ordem'
  key          SoldToParty,
               @EndUserText.label: 'Data de criação do pedido'
               @Consumption.filter.mandatory: true
               CreationDate,
               @Consumption.filter.hidden: true
               @EndUserText.label: 'Nome Emissor da ordem'
               SoldToPartyName,
               @EndUserText.label: 'Referência do cliente'
               @Consumption.valueHelpDefinition: [ { entity:  { name:    'ZI_CA_VH_REF_CLIENTE', element: 'Referencia' } }]
               PurchaseOrderByCustomer,
               @EndUserText.label: 'Data solicitada de remessa'
               RequestedDeliveryDate,

               @Consumption.filter.hidden: true
               SalesOrganization,
               //         @Consumption.filter.hidden: true
               @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VTWEG', element: 'CanalDistrib' } } ]
               DistributionChannel,
               @Consumption.filter.hidden: true
               OrganizationDivision,
               //         @Consumption.filter.hidden: true
               //          @EndUserText.label: 'Paletização'
               //          //        CustomerAccountAssignmentGroup,
               //          //         cast( PalletTotal as ze_paletizacao  preserving type ) as PalletTotal,
               //          PalletTotal,
               //          @EndUserText.label: 'Pallet Fracionado'
               //          PalletFracionado,
               @Consumption.filter.hidden: true
               @Consumption.hidden: true
               SalesOrderI,
               @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_WERKS', element: 'WerksCode' }}]
               @Consumption.filter.mandatory: true
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
               @Consumption.filter.hidden: true
               @EndUserText.label: 'Material'
               Material,
               @Consumption.filter.hidden: true
               @EndUserText.label: 'Descrição produto'
               SalesOrderItemText,
               @Consumption.filter.hidden: true
               @EndUserText.label: 'Volumes'
               ItemVolume,
               @Consumption.filter.hidden: true
               @EndUserText.label: 'Unidade de Volume'
               //         @UI.hidden: true
               ItemVolumeUnit,
               @Consumption.filter.hidden: true
               @EndUserText.label: 'Unidade de medida'
               OrderQuantityUnit,
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
               @ObjectModel.text: { element: ['AgrupametoText'] }
               @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_KVGR5', element: 'Agrupamento' }}]
               kvgr5,
               @Consumption.filter.hidden: true
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
               @EndUserText.label: 'Docnum NF-e'
               DocNum,
               @EndUserText.label: 'Total NF-e'
               @Consumption.filter.hidden: true
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
               //          DataFrete,
               //            @EndUserText.label: 'Data de entrega'
               //            DataEntrega,
               //          dats,
               @EndUserText.label: 'Paletização'
               @ObjectModel.virtualElement: true
               @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CKPT_AGEND_PALLET'
  virtual      PalletTotal      : abap.char( 20 ),
               @EndUserText.label: 'Pallet Fracionado'
               @ObjectModel.virtualElement: true
               @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CKPT_AGEND_PALLET'
  virtual      PalletFracionado : abap.char( 20 ),

               @EndUserText.label: 'Data de entrega'
               @ObjectModel.virtualElement: true
               @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CKPT_AGEND_DATAENTREGA'
  virtual      DataEntrega      : abap.char( 20 ),

               //                   @Consumption.filter.hidden: true
               //                   @EndUserText.label: 'Data de entrega'
               //                   DataEntrega,
               //
               ////          @Consumption.filter.hidden: true
               //            @EndUserText.label: 'Data de entrega'
               //            @Consumption.hidden: true
               //            @ObjectModel: { virtualElement: true,
               //                   virtualElementCalculatedBy: 'ABAP:ZCLSD_CKPT_AGEND_CONV' }
               //  virtual   DataEntrega      : abap.char( 20 ),
               @EndUserText.label: 'Data agendada'
               DataAgendada,
               @EndUserText.label: 'Hora agendada'
               //         @Consumption.filter.hidden: true
               HoraAgendada,
               //         @Consumption.filter.hidden: true
               //               @EndUserText.label: 'Motivo Agenda'
               //               MotivoAgenda,
               //         @Consumption.filter.hidden: true

               @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_VSTGA', element: 'Motivo' }}]
               @EndUserText.label: 'Motivo Agenda'
               MotivoAgenda,
               @EndUserText.label: 'Descrição Motivo Agenda'
               MotivoText,
               @Consumption.filter.hidden: true
               @EndUserText.label: 'Senha Cliente'
               Senha,
               @Consumption.filter.hidden: true
               @EndUserText.label: 'Observações'
               Observacoes,
               @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_ESTADO', element: 'Valor' }}]
               @ObjectModel.text: { element: ['StatusText'] }
               Status,
               @UI.hidden: true
               StatusText,
               @UI.hidden: true
               @Consumption.filter.hidden: true
               StatusColor,
               @Consumption.filter.hidden: true
               @Consumption.hidden: true
               Salesorder_conv,
               @Consumption.filter.hidden: true
               @Consumption.hidden: true
               time_zone,
               /* Associations */
               _Cliente,
               _Grupo,
               _Item,
               _Partner
               //               _Remessa,
               //               @Consumption.filter.hidden: true
               //               _Mot
}
