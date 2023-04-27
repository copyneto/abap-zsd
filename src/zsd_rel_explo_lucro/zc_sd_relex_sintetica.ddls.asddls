@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'ZC_SD_RELEX_Sintetica'
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_SD_RELEX_Sintetica
  as select from ZC_SD_RELEX_VW_Sintetica
{
  key    Plant,
  key    BR_NFNumber,
         @EndUserText.label: 'Lote venda'
  key    Batch,
  key    ValuationType,
  key    BR_CFOPCode,
  key    SalesDocumentCurrency,
  key    BR_NFDocumentType,
  key    SalesOrganization,
         @EndUserText.label: 'Org de Venda e Atividade'
  key    SalesOrgAtv,
         @EndUserText.label: 'Atividade'
  key    AdditionalMaterialGroup3Name,
         CompanyCode,
         @Semantics.amount.currencyCode:'SalesDocumentCurrency'
         @EndUserText.label: 'Vlr Trans'
         ValorTrans,
         @Semantics.amount.currencyCode:'SalesDocumentCurrency'
         @EndUserText.label: 'Vlr Transação'
         BR_NFTotalAmount_sum,
         @Semantics.amount.currencyCode:'SalesDocumentCurrency'
         @EndUserText.label: 'Valor COFINS'
         VlrCONFIS_sum,
         @Semantics.amount.currencyCode:'SalesDocumentCurrency'
         @EndUserText.label: 'Valor do ICMS'
         VlrICMS_sum,
         @Semantics.amount.currencyCode:'SalesDocumentCurrency'
         @EndUserText.label: 'Valor do IPI'
         VlrIPI_sum,
         @Semantics.amount.currencyCode:'SalesDocumentCurrency'
         @EndUserText.label: 'Valor PIS'
         VlrPIS_sum,
         @Semantics.amount.currencyCode:'SalesDocumentCurrency'
         @EndUserText.label: 'Valor Sub.Trib'
         VlrSUBTRIB_sum,
         @EndUserText.label: 'Quantidade'
         QtyEmKg_sum
}
