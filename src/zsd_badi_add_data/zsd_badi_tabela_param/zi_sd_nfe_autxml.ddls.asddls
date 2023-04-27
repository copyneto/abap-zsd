@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Autorização para obter XML'
define root view entity ZI_SD_NFE_AUTXML
  as select from ztsd_nfe_autxml
{
  key branch                as LocalNegocios,
      cnpj                  as Cnpj,
      cpf                   as Cpf,
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
