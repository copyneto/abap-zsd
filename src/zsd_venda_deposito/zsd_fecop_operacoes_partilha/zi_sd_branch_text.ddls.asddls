@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Local de negócios - Textos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_SD_BRANCH_TEXT
  as select from j_1bbranch           as Branch
    inner join   ZI_SD_SALES_ORG_TEXT as SalesOrgText
      on Branch.bukrs = SalesOrgText.SalesOrgID
  association to j_1bbrancht as _Text
    on  $projection.Company           = _Text.bukrs
    and $projection.BusinessPlace     = _Text.branch
    and $projection.BusinessPlaceType = _Text.bupla_type
    and _Text.language                = $session.system_language

{
  key Branch.bukrs      as Company,
      @ObjectModel.text.element: ['Name']
  key Branch.branch     as BusinessPlace,
  key Branch.bupla_type as BusinessPlaceType,
      @Search.defaultSearchElement: true
      _Text.name        as Name

}
