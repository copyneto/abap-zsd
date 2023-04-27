@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Texto Def. ICMS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REL_FISCAL_SAIDA_ICMSTXT
  as select from j_1batl1t as TaxLawICMSText
{
      @Semantics.language: true
  key langu   as Language,
  key taxlaw  as BR_ICMSTaxLaw,
      descrip as BR_ICMSTaxLawDesc,
      line1   as BR_ICMSTaxLawLine1,
      line2   as BR_ICMSTaxLawLine2,
      line3   as BR_ICMSTaxLawLine3,
      line4   as BR_ICMSTaxLawLine4
}
