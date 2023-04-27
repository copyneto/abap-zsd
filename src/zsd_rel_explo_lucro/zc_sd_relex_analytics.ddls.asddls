@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'ZC_SD_RELEX_Analytics'
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_SD_RELEX_Analytics
  as select from ZI_SD_RELEX_APP
{
      @ObjectModel.text.element: ['CompanyCodeName']
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_CA_VH_BUKRS', element: 'Empresa'  } }]
  key CompanyCode,
      @EndUserText.label: 'Data NF'
  key CreationDate,
      @EndUserText.label           : 'N° Nota Fiscal'
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_CA_VH_NFENUM', element: 'nfenum' }} ]
  key BR_NFNumber,
  key BusinessPlace,
  key BR_NFDocumentType,
      @EndUserText.label: 'Docnum'
  key BR_NotaFiscal,
  key BR_NotaFiscalItem,
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_CA_VH_WERKS', element: 'WerksCode'  } }]
  key Plant,
      //      @ObjectModel.text.element: ['MaterialName']
  key Material,
      @EndUserText.label: 'Lote venda'
  key Batch,
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_SD_RELEX_VH_BWTAR', element: 'Bwtar' }} ]
  key ValuationType,
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_CA_VH_CFOP', element: 'Cfop1' }} ]
  key BR_CFOPCode,
  key BR_ReferenceNFNumber,
  key BR_ReferenceNFItem,
      @EndUserText.label: 'Doc.Fatura'
  key BR_NFSourceDocumentNumber,
  key BaseUnit,
  key doc_type,
  key MaterialName,
  key CompanyCodeName,
  key SalesDocumentCurrency,
      BusinessArea,
      @EndUserText.label: 'Período Contábil'
      @Consumption.valueHelpDefinition:   [{  entity: {name: 'ZI_SD_RELEX_VH_FISCALMONTH', element: 'Mes' } }]
      FiscalMonthCurrentPeriod,
      @EndUserText.label: 'Exercício'
      @Consumption.valueHelpDefinition:   [{  entity: {name: 'ZI_SD_RELEX_VH_FISCALYEAR', element: 'lfgja' } }]
      FiscalYearCurrentPeriod,
      @EndUserText.label: 'Atividade'
      AdditionalMaterialGroup3Name,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      @Aggregation.default: #SUM
      QtyDelivery,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      @Aggregation.default: #SUM
      @EndUserText.label: 'Vlr Bruto'
      //      BR_NFTotalAmount,
      ValorTrans,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      @Aggregation.default: #SUM
      VlrCONFIS,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      @Aggregation.default: #SUM
      VlrICMS,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      @Aggregation.default: #SUM
      VlrIPI,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      @Aggregation.default: #SUM
      VlrPIS,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      @Aggregation.default: #SUM
      VlrSUBTRIB,
      @EndUserText.label: 'Vlr Líquido'
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      @Aggregation.default: #SUM
      VlrTransLiq,

      MaterialBaseUnit,
      cast('KG' as msehi) as UnitKG,
      @Semantics.quantity.unitOfMeasure: 'UnitKG'
      @Aggregation.default: #SUM
      QtyEmKg,
      StatusNF,
      @ObjectModel.text.element: ['StatusNFText']
      StatusNFText

}
