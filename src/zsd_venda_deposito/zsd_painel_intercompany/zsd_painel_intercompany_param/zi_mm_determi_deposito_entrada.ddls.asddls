@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Determinação Depósito de Entrada'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zi_mm_determi_deposito_entrada
  as select from ztmm_det_dep_ent
{
  key werks                 as Werks,
      lgort                 as Lgort,
      created_by            as CreatedBy,
      created_at            as CreatedAt,
      last_changed_by       as LastChangedBy,
      last_changed_at       as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt
}
