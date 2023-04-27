@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Texto Def. IPI'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REL_FISCAL_SAIDA_IPITXT
  as select from j_1batl2t as TaxLawIPIText
{
      @Semantics.language: true
  key langu   as Language,
  key taxlaw  as BR_IPITaxLaw,
      descrip as BR_IPITaxLawDesc,
      line1   as BR_IPITaxLawLine1,
      line2   as BR_IPITaxLawLine2,
      line3   as BR_IPITaxLawLine3,
      line4   as BR_IPITaxLawLine4
}
