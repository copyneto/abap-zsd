@AbapCatalog.sqlViewName: 'ZSD_RELEXVWS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Visão com a analise Sintética'
define view ZC_SD_RELEX_VW_Sintetica
  as select from ZI_SD_RELEX_APP
{

  key Plant,
      CompanyCode,
      BR_NFNumber,
      Batch,
      ValuationType,
      BR_CFOPCode,
      BR_NFDocumentType,
      // UnitKG,
      // QtyEmKg,
      @Semantics.currencyCode
      SalesDocumentCurrency,
      SalesOrganization,
      AdditionalMaterialGroup3Name,
      SalesOrgAtv,
      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      sum(ValorTrans)       as ValorTrans,
      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      sum(BR_NFTotalAmount) as BR_NFTotalAmount_sum,
      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      sum(VlrCONFIS)        as VlrCONFIS_sum,
      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      sum(VlrICMS)          as VlrICMS_sum,
      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      sum(VlrIPI)           as VlrIPI_sum,
      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      sum(VlrPIS)           as VlrPIS_sum,
      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      sum(VlrSUBTRIB)       as VlrSUBTRIB_sum,
      sum(QtyEmKg)          as QtyEmKg_sum
}
group by
  Plant,
  CompanyCode,
  BR_NFNumber,
  Batch,
  ValuationType,
  BR_CFOPCode,
  BR_NFDocumentType,
  SalesDocumentCurrency,
  SalesOrganization,
  AdditionalMaterialGroup3Name,
  SalesOrgAtv
