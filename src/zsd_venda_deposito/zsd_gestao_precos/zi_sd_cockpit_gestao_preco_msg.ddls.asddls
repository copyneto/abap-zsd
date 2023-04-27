@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Gestão de Preço - Mensagem'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COCKPIT_GESTAO_PRECO_MSG
  as select from ztsd_preco_msg
  association to parent ZI_SD_COCKPIT_GESTAO_PRECO as _Cockpit on _Cockpit.Guid = $projection.Guid
{
  key guid                  as Guid,
  key line                  as Line,
  key msg_line              as MsgLine,
      message               as Message,
      line_criticality      as LineCriticality,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _Cockpit
}
