@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS SM30 AGEND PALLET'
define root view entity ZI_SD_CKPT_AGEND_PALLET
  as select from ztsd_agenda001 as _Main

  association [0..1] to ZI_CA_VH_MATERIAL as _Material on _Material.Material = $projection.Material
  association [0..1] to ZI_CA_VH_KUNNR    as _Cliente  on _Cliente.Kunnr = $projection.Cliente
{
  key     _Main.guid                                      as Guid,
          _Main.material                                  as Material,
          _Material.Text                                  as MaterialTexto,
          _Main.lastro                                    as Lastro,
          _Main.altura                                    as Altura,
          _Main.cliente                                   as Cliente,
          _Cliente.KunnrName                              as ClienteTexto,
          _Main.qtd_total                                 as QtdTotal,
          _Main.unidade_de_medida_pallet                  as UnidadeDeMedidaPallet,
          @Semantics.user.createdBy: true
          _Main.created_by                                as CreatedBy,
          @Semantics.systemDateTime.createdAt: true
          cast(_Main.created_at as timestamp )            as CreatedAt,
          @Semantics.user.lastChangedBy: true
          _Main.last_changed_by                           as LastChangedBy,
          @Semantics.systemDateTime.lastChangedAt: true
          cast(_Main.last_changed_at as timestamp )       as LastChangedAt,
          @Semantics.systemDateTime.localInstanceLastChangedAt: true
          cast(_Main.local_last_changed_at as timestamp ) as LocalLastChangedAt
}
