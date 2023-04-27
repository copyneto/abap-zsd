@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'ApP Gestão de furto e extravio'
@Metadata.allowExtensions: true
define root view entity ZC_SD_FURTO_EXTRAVIO_APP
  as projection on ZI_SD_FURTO_EXTRAVIO_APP
{


          @EndUserText.label:'Ordem Nota de Débito'
  key     SalesOrderDeb,
  key     SubsequentDocument,
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_ORDEM_VENDA', element: 'SalesOrder' }}]
          @EndUserText.label:'Ordem de Venda'
  key     SalesOrder,
          @EndUserText.label:'Data de Criação da Venda'
          CreationDate,
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_DISTRIBUTIONCHANNEL', element: 'OrgUnidID' }}]
          DistributionChannel,
          @EndUserText.label: 'Número do Pedido'
          PurchaseOrderByCustomer,
          @EndUserText.label: 'NF-e de Venda'
          BR_NFeNumber,
          @EndUserText.label: 'Nota Débito'
          CorrespncExternalReference,
          //@ObjectModel.text.element: ['SoldtopartyName']
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_EMISSOR_ORDEM', element: 'Kunnr' }}]
          @EndUserText.label: 'Transportadora'
          Soldtoparty,
          @EndUserText.label: 'Nome da transportadora'
          SoldtopartyName,
          @ObjectModel.text.element: ['SDdocumentreasonText']
          SDdocumentreason,
          SDdocumentreasonText,
          //@Consumption.valueHelpDefinition: [{entity: {name: 'I_Plant', element: 'Plant' }}]
          @ObjectModel.text.element: ['PlantName']
          @Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_SD_VH_WERKS_PAR', element: 'WerksCode'  } }]
          @EndUserText.label: 'Centro'
          ShippingPoint,
          PlantName,
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STAUSOVDEB', element: 'Text' }}]
          Status,
          StatusColor,
          @ObjectModel: { virtualElement: true,
          virtualElementCalculatedBy: 'ABAP:ZCLSD_OV_DEB_ECO_URL' }
  virtual URL_SalesOrder    : eso_longtext,
          @ObjectModel: { virtualElement: true,
          virtualElementCalculatedBy: 'ABAP:ZCLSD_OV_DEB_ECO_URL' }
  virtual URL_SalesOrderDeb : eso_longtext
}
