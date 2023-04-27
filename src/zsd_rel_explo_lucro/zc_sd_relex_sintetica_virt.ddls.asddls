@EndUserText.label: 'Relatório Lucro da Exploração Sintética'
@UI.headerInfo: { typeName: 'CFOP',
                  typeNamePlural: 'Rel. Lucro Exp. Sintético' }

@ObjectModel: { query.implementedBy: 'ABAP:ZCLSD_RLAT_LUCROEXPL_SINT'}
@UI.presentationVariant: [{ includeGrandTotal: false }]
define custom entity ZC_SD_RELEX_SINTETICA_VIRT
{

      @UI.lineItem                 : [{position: 20 }]
      @UI.selectionField           : [{ position: 20 }]
      @EndUserText.label           : 'Centro'
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_CA_VH_WERKS', element: 'WerksCode' }} ]
      @Consumption.filter.mandatory: true
  key Plant                        : werks_d;

      @UI.lineItem                 : [{position: 70 }]
      @UI.selectionField           : [{ position: 40 }]
      @EndUserText.label           : 'Tipo de Avaliação'
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_SD_RELEX_VH_BWTAR', element: 'Bwtar' }} ]
  key ValuationType                : logbr_bwtar_d;

      @UI.lineItem                 : [{position: 80 }]
      @UI.selectionField           : [{ position: 30 }]
      @EndUserText.label           : 'CFOP'
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_CA_VH_CFOP', element: 'Cfop1' }} ]
  key BR_CFOPCode                  : logbr_cfopcode;

      @UI.lineItem                 : [{position: 10 }]
      @EndUserText.label           : 'Tipo de Documento'
      BR_NFDocumentType            : char2;

      @UI.selectionField           : [{ position: 10 }]
      @EndUserText.label           : 'Empresa'
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_CA_VH_BUKRS', element: 'Empresa' }} ]
      @Consumption.filter.mandatory: true
      CompanyCode                  : bukrs;

      @UI.lineItem                 : [{position: 60 }]
      @EndUserText.label           : 'N° Nota Fiscal'
      @UI.selectionField           : [{ position: 50 }]
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_SD_RELEX_FILT_NFDOCUM', element: 'BR_NFNumber' }} ]
      BR_NFNumber                  : logbr_nfnumb;

      @UI.lineItem                 : [{position: 30 }]
      @EndUserText.label           : 'Org. de Vendas'
      SalesOrganization            : vkorg;

      @UI.lineItem                 : [{ position: 40 }]
      @EndUserText.label           : 'Org de Vendas e Atividade'
      SalesOrgAtv                  : char45;

//      @UI.selectionField           : [{ position: 60 }]
      @EndUserText.label           : 'Período Contábil'
      @Consumption.valueHelpDefinition:   [{  entity: {name: 'ZI_SD_RELEX_VH_FISCALMONTH', element: 'Mes' } }]
      FiscalMonthCurrentPeriod     : lfmon;

      @UI.selectionField           : [{ position: 70 }]
      @EndUserText.label           : 'Exercício'
      @Consumption.valueHelpDefinition:   [{  entity: {name: 'ZI_SD_RELEX_VH_FISCALYEAR', element: 'lfgja' } }]
      FiscalYearCurrentPeriod      : lfgja;

      @UI.lineItem                 : [{ position: 50 }]
      @EndUserText.label           : 'Atividade'
      AdditionalMaterialGroup3Name : bezei40;

      @UI.lineItem                 : [{position: 60 }]
      @EndUserText.label           : 'Lote venda'
      Batch                        : charg_d;

      @UI.hidden                   : true
      SalesDocumentCurrency        : waerk;

      @UI.hidden                   : true
      BaseUnit                     : j_1bnetunt;

      @Semantics.quantity.unitOfMeasure:'BaseUnit'
      @UI.lineItem                 : [{position: 90 }]
      @EndUserText.label           : 'Quantidade'
      @Aggregation.default         : #SUM
      QtyDelivery                  : j_1bnetqty;

//      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
//      @UI.lineItem                 : [{position: 100 }]
//      @EndUserText.label           : 'Vlr Transação'
//      @Aggregation.default         : #SUM
//      BR_NFTotalAmount             : j_1bnfnett;
      
      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      @UI.lineItem                 : [{position: 100 }]
      @EndUserText.label           : 'Vlr Líquido'
      @Aggregation.default         : #SUM
      vlrliq                       : j_1bnfnett;

      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      @UI.lineItem                 : [{position: 110 }]
      @EndUserText.label           : 'Valor do ICMS'
      @Aggregation.default         : #SUM
      VlrICMS_sum                  : j_1btaxval;

      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      @UI.lineItem                 : [{position: 120 }]
      @EndUserText.label           : 'Valor do IPI'
      @Aggregation.default         : #SUM
      VlrIPI_sum                   : j_1btaxval;

      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      @UI.lineItem                 : [{position: 130 }]
      @EndUserText.label           : 'Valor Sub.Trib'
      @Aggregation.default         : #SUM
      VlrSUBTRIB_sum               : j_1btaxval;

      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      @UI.lineItem                 : [{position: 140 }]
      @EndUserText.label           : 'Valor PIS'
      @Aggregation.default         : #SUM
      VlrPIS_sum                   : j_1btaxval;

      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      @UI.lineItem                 : [{position: 150 }]
      @EndUserText.label           : 'Valor COFINS'
      @Aggregation.default         : #SUM
      VlrCONFIS_sum                : j_1btaxval;

      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      @UI.lineItem                 : [{position: 160 }]
      @EndUserText.label           : 'Valor Bruto'
      @Aggregation.default         : #SUM
      ValorTrans                   : j_1btaxval;

      @UI.selectionField           : [{ position: 80 }]
      @EndUserText.label           : 'Data NF'
      @Consumption.filter.selectionType: #INTERVAL
      CreationDate                 : logbr_credat;

      @UI.selectionField           : [{ position: 90 }]
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_SD_RELEX_VH_CODESTATUS', element: 'Code' }} ]
      StatusNF                     : j_1bstatuscode;

      //  @UI.lineItem: [{position: 120, label: 'Vlr Transação' }]
      //  BR_NFTotalAmount_sum : ;

      //  @UI.lineItem: [{position: 100 }]
      //  QtyEmKg_sum;

}
