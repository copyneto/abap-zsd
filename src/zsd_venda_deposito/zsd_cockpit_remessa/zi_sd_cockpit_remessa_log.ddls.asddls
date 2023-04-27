@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit gerenciamento de remessas - Log'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COCKPIT_REMESSA_LOG
  as select from ZI_SD_REMESSA_INFO_DOCS as _Header
    inner join   ztsd_cp_rem_log         as _Log on _Log.vbeln_vl = _Header.DeliveryDocument

  association        to parent ZI_SD_COCKPIT_REMESSA as _Cockpit       on  _Cockpit.SalesDocument    = $projection.SalesDocument
                                                                       and _Cockpit.OutboundDelivery = $projection.OutboundDelivery

  association [0..1] to ZI_CA_VH_USER                as _CreatedBy     on  _CreatedBy.Bname = $projection.CreatedBy
  association [0..1] to ZI_CA_VH_USER                as _LastChangedBy on  _LastChangedBy.Bname = $projection.LastChangedBy
{
  key _Header.SalesDocument      as SalesDocument,
  key _Header.DeliveryDocument   as OutboundDelivery,
  key _Log.line                  as Line,

      case  _Log.msgty
      when 'S' then 3  -- Mensagem na tela seguinte
      when 'I' then 0  -- Informação
      when 'A' then 1  -- Cancelamento
      when 'E' then 1  -- Erro
      when 'W' then 2  -- Advertência
               else 0 end        as Criticality,

      _Log.msgty                 as Msgty,
      _Log.msgid                 as Msgid,
      _Log.msgno                 as Msgno,
      _Log.msgv1                 as Msgv1,
      _Log.msgv2                 as Msgv2,
      _Log.msgv3                 as Msgv3,
      _Log.msgv4                 as Msgv4,
      _Log.message               as Message,
      @Semantics.user.createdBy: true
      _Log.created_by            as CreatedBy,
      _CreatedBy.Text            as CreatedByName,
      @Semantics.systemDateTime.createdAt: true
      _Log.created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      _Log.last_changed_by       as LastChangedBy,
      _LastChangedBy.Text        as LastChangedByName,
      @Semantics.systemDateTime.lastChangedAt: true
      _Log.last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      _Log.local_last_changed_at as LocalLastChangedAt,

      /* associations */
      _Cockpit
}
