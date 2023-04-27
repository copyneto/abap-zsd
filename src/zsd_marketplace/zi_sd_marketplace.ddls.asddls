@AbapCatalog.sqlViewName: 'ZVSDMARKETPLACE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Interface Marketplace'
define root view ZI_SD_MARKETPLACE
  as select from ztsd_t048
{
  key lifnr                 as Lifnr,
      idcadinttran          as Idcadinttran,
      cnpjintermed          as Cnpjintermed,
      indintermed           as Indintermed,
      ind_pres              as IndPres,
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
