@EndUserText.label: 'VisãoConsumo - Relatório analítico devolução'
@AccessControl.authorizationCheck: #CHECK
@VDM.viewType: #CONSUMPTION
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_SD_BR_REL_ANALIT_DEVOLUCAO
  as projection on ZI_SD_BR_REL_ANALITICO_DEVOLUC as Devolucao
{

  key BR_NotaFiscal,
  key NFItemDev,
      key NFDev,
      
      @Consumption.valueHelpDefinition: [{ entity: {name: 'I_CompanyCodeVH' , element: 'CompanyCode'}}]
      CompanyCodeDev,
      CompanyCodeNameDev,
      @Consumption.valueHelpDefinition: [{
            entity: {
                name: 'ZI_CA_VH_SALESORG', element: 'SalesOrgID'
            }
          }]
      SalesOrganizationDev,
      @Consumption.valueHelpDefinition: [{ entity : { name: 'ZI_CA_SETOR_ATIV_LIST', element : 'Division' } }]
      DivisionDev,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BR_NFBusinessPlace_SH', element: 'Branch' },
                                           additionalBinding: [{ element: 'CompanyCode', localElement: 'CompanyCodeDev' } ]}]
      BusinessPlaceDev,
      BusinessPlaceNameDev,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Plant', element: 'Plant' } }]
      PlantDev,
      BR_PlantNameDev,
      CreatedByUserDev,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_DistributionChannel', element: 'DistributionChannel' } }]
      DistributionChannelDev,
      DistributionChannelTextDev,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BR_NFPartner', element: 'BR_NFPartner' } }]
      PartnerDev,
      PartnerNameDev,
      PartnerCNPJDev,
      PartnerRegionDev,
      PartnerCityDev,
      @Consumption.valueHelpDefinition: [{ entity: { name : 'I_SalesDocumentType', element: 'SalesDocumentType' } }]
      SalesOrderTypeDev,
      DocumentTypeNameDev,
      SalesDocumentDev,
      ReferenceDocumentDev,
      BillingDateDev,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BILLINGDOCUMENTTYPE', element: 'BillingDocumentType' } }]
      BillingDocTypeDev,
      ProductHierarchyNodeDev,
      ProductHierarchyTextDev,
      MaterialDev,
      MaterialNameDev,
      QuantityDev,
      BaseUnitDev,
      QuantityUMBDev,
      MaterialBaseUnitDev,
      QuantityKgDev,
      UnidKgDev,
      NFeNumberDev,
      NCMDev,
      CreationDataDev,
      NFPostingDateDev,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_CFOP', element: 'Cfop' } }]
      CFOPDev,
      @Aggregation.default: #SUM
      NFeTotalDev,
      @Aggregation.default: #SUM
      NetValueDev,
      HeaderGrossWeightDev,
      @Consumption.valueHelpDefinition: [{entity: { name: 'I_BR_NotaFiscalTypeText', element: 'BR_NFType' } }]
      NFTypeDev,
      @Aggregation.default: #SUM
      ICMSItemBaseAmountDev,
      @Aggregation.default: #SUM
      ICMSItemTaxAmountDev,
      @Aggregation.default: #SUM
      IPIItemBaseAmountDev,
      @Aggregation.default: #SUM
      IPIItemTaxAmountDev,
      @Aggregation.default: #SUM
      ICSTItemBaseAmountDev,
      @Aggregation.default: #SUM
      ICSTItemTaxAmountDev,
      @Aggregation.default: #SUM
      PISItemBaseAmountDev,
      @Aggregation.default: #SUM
      PISItemTaxAmountDev,
      @Aggregation.default: #SUM
      COFIItemBaseAmountDev,
      @Aggregation.default: #SUM
      COFIItemTaxAmountDev,
      //----------------------------------------------------------------Saída
      SalesOrderTypeInv,
      DocumentTypeNameInv,
      NFInv,
      NFeNumberInv,
      OriginReferenceDocumentInv,
      ReferenceDocumentInv,
      NFPostingDateInv,
      CreationDateInv,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_CFOP', element: 'Cfop' } }]
      CFOPInv,
      QuantityInv,
      BaseUnitInv,
      QuantityUMBInv,
      MaterialBaseUnitInv,
      QuantityKgInv,
      UnidKgInv,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BILLINGDOCUMENTTYPE', element: 'BillingDocumentType' } }]
      BillingDocTypeInv,
      @Aggregation.default: #SUM
      NetValueAmountInv,
      @Aggregation.default: #SUM
      NFeTotalInv,
      @Consumption.valueHelpDefinition: [{entity: { name: 'I_BR_NotaFiscalTypeText', element: 'BR_NFType' } }]
      NFTypeInv,
      @Aggregation.default: #SUM
      ICMSItemBaseAmountInv,
      @Aggregation.default: #SUM
      ICMSItemTaxAmountInv,
      @Aggregation.default: #SUM
      IPIItemBaseAmountInv,
      @Aggregation.default: #SUM
      IPIItemTaxAmountInv,
      @Aggregation.default: #SUM
      ICSTItemBaseAmountInv,
      @Aggregation.default: #SUM
      ICSTItemTaxAmountInv,
      @Aggregation.default: #SUM
      PISItemBaseAmountInv,
      @Aggregation.default: #SUM
      PISItemTaxAmountInv,
      @Aggregation.default: #SUM
      COFIItemBaseAmountInv,
      @Aggregation.default: #SUM
      COFIItemTaxAmountInv,
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_SDDocumentReason', element: 'SDDocumentReason' } } ]
      SDDocumentReasonDev,
      SDDocumentReasonTextDev,
      AreaRespDev,
      ImpactoDev,
      EmbarqueDev,
      QualidadeDev,
      SupplierInv,
      SupplierNameInv,
      SupplierId,
      DriverInv,
      DriverNameInv,
      DriverId,
      OrdemFreteInv,
      GrossWeightInv,
      RouteInv,
      SalesDistrictInv,
      SalesDistrictNameInv,
      SalesOfficeInv,
      SalesDocumentCurrencyDev,
      GrossWeightUnitInv,
      @Consumption.valueHelpDefinition: [{entity: { name: 'ZI_CA_TP_DOC_NF', element: 'BR_NFIsCreatedManually' } }]
      CreatedManuallyDev,
      @Consumption.valueHelpDefinition: [{entity: { name: 'ZI_CA_VH_DIRECAO_NF', element: 'BR_NFDirection' } }]
      @ObjectModel.text.element: ['DirectionDesc']
      DirectionDev,
      DirectionDesc,
      //      @Aggregation.default: #SUM
      //      Accuracy,

      /* Associations */
      RouteTextInv
}
