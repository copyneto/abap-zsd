@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Condições deduzidas da base PIS COFINS'
define root view entity ZI_SD_COND_PIS_CONFIS
  as select from ztsd_pisconfis
{
  key bukrs                 as Bukrs,
  key data_dev              as DataDev,
      data_fim              as DataFim,
      icms_amt              as IcmsAmt,
      icms_fcp_amt          as IcmsFcpAmt,
      icms_dest_part_amt    as IcmsDestPartAmt,
      icms_fcp_partilha_amt as IcmsFcpPartilhaAmt,
      created_by            as CreatedBy,
      created_at            as CreatedAt,
      last_changed_by       as LastChangedBy,
      last_changed_at       as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt
}
