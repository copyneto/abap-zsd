@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface Controle Determinação Depósito'
define root view entity ZI_SD_CTR_DET_DEP
  as select from ztsd_ctr_det_dep
{
  key auart                 as Auart,
  key kunnr                 as Kunnr,
  key augru                 as Augru,
  key matkl                 as Matkl,
  key bsark                 as Bsark,
  key werks                 as Werks,
      lgort                 as Lgort,
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
 