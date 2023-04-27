@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Separação de ICMS e FCP por Estado'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
@Metadata.allowExtensions: true
define root view entity ZI_SD_FECOP_ICMS
  as select from ztsd_fecop_icms
  association [0..1] to ZI_SD_SALES_ORG_TEXT as _SalesOrgText
    on $projection.SalesOrgID = _SalesOrgText.SalesOrgID
  association [0..1] to ZI_SD_BRANCH_TEXT    as _BranchText
    on  $projection.SalesOrgID      = _BranchText.Company
    and $projection.BusinessPlaceID = _BranchText.BusinessPlace

{
  key vkorg                 as SalesOrgID,
  key branch                as BusinessPlaceID,
      _SalesOrgText.Text    as SalesOrg,
      _BranchText.Name      as BusinessPlace,

      @Semantics.user.createdBy: true
      created_by            as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,

      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,

      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt
}
