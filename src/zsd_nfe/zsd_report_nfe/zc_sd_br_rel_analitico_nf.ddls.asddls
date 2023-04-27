@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'VisãoConsumo - Relatório Analítico de NF'
@VDM.viewType: #CONSUMPTION
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_SD_BR_REL_ANALITICO_NF
  as select from ZI_SD_BR_REL_ANALITICO_NF
{

  key BR_NotaFiscal,

  key BR_NotaFiscalItem,

      @Consumption.valueHelpDefinition: [{ entity: {name: 'I_CompanyCodeVH' , element: 'CompanyCode'}}]
      CompanyCode,

      CompanyCodeName,

      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BR_NFBusinessPlace_SH', element: 'Branch' },
                                           additionalBinding: [{ element: 'CompanyCode', localElement: 'CompanyCode' } ]}]
      BusinessPlace,

      BusinessPlaceName,

      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Plant', element: 'Plant' } }]
      Plant,

      CreatedByUser,

      CancellationChangedByUser,

      ZBR_NFPartner,

      BR_NFReceiverNameFrmtdDesc,

      //@Consumption.valueHelpDefinition: [{ entity : { name: 'I_BR_NFDOCUMENT', element: 'BR_NFENUMBER'  } }]
      BR_NFeNumber,

      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_CFOP', element: 'Cfop' } }]
      BR_CFOPCode,

      BR_NFIssueDate,

      BR_NFPostingDate,

      CreationTime,

      BR_NFCancellationDate,

      LastChangeTime,

      Material,

      MaterialName,


      QuantityInBaseUnit,

      BaseUnit,

      SalesDocumentCurrency,

      //@Semantics.amount.currencyCode:'SalesDocumentCurrency'
      @Aggregation.default: #SUM
      NetValueAmount,

      @Aggregation.default: #SUM
      BR_ICMSBaseAmount,

      @Aggregation.default: #SUM
      BR_ICMSTaxAmount,

      @Aggregation.default: #SUM
      ZBR_IPIBaseAmount,

      @Aggregation.default: #SUM
      BR_IPITaxAmount,

      @Aggregation.default: #SUM
      BR_ICMSSTBaseAmount,

      @Aggregation.default: #SUM
      BR_ICMSSTAmount,

      @Aggregation.default: #SUM
      BR_ICMSDestinationTaxAmount,

      @Aggregation.default: #SUM
      BR_ICMSOriginTaxAmount,

      @Aggregation.default: #SUM
      BR_FCPOnICMSTaxAmount,

      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_DistributionChannel', element: 'DistributionChannel' } }]
      DistributionChannel,

      //@Consumption.valueHelpDefinition: [{ entity : { name: 'ZI_SD_MOTIVO_ORDEM_ENTITY', element : 'Augru' } }]
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_SDDocumentReason', element: 'SDDocumentReason' } } ]
      SDDocumentReason,

      @Consumption.valueHelpDefinition: [{ entity : { name: 'ZI_CA_SETOR_ATIV_LIST', element : 'Division' } }]
      Division,

      @Consumption.valueHelpDefinition: [{entity: { name: 'ZI_CA_VH_PARTYP_LIST', element: 'BR_NFPartnerType' } }]
      BR_NFPartnerType,

      BR_NFIsCanceled,

      @Consumption.valueHelpDefinition: [{entity: { name: 'I_BR_NotaFiscalTypeText', element: 'BR_NFType' } }]
      BR_NFType,

      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BILLINGDOCUMENTTYPE', element: 'BillingDocumentType' } }]
      BillingDocumentType,

      @Consumption.valueHelpDefinition: [{entity: { name: 'I_BR_NFeDocumentStatus', element: 'BR_NFeDocumentStatus' } }]
      @ObjectModel.text.element: ['BR_NFeDocumentStatusDesc']
      BR_NFeDocumentStatus,

      BR_NFeDocumentStatusDesc,

      @Consumption.valueHelpDefinition: [{entity: { name: 'ZI_CA_TP_DOC_NF', element: 'BR_NFIsCreatedManually' } }]
      BR_NFIsCreatedManually,

      @Consumption.valueHelpDefinition: [{entity: { name: 'ZI_CA_VH_DIRECAO_NF', element: 'BR_NFDirection' } }]
      @ObjectModel.text.element: ['BR_NFDirectionDesc']
      BR_NFDirection,

      BR_NFDirectionDesc

}
