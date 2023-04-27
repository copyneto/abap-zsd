@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Hora Corte'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_sd_02_hora
  as select from ztsd_hora_corte as hora
    inner join   ZI_CA_VH_DIAS   as d on d.Dias = hora.zdia
  association to parent ZI_SD_01_NIVEL as _Nivel on  $projection.Ziti = _Nivel.Ziti
                                                 and $projection.Zmed = _Nivel.Zmed
{
  key hora.ziti                  as Ziti,
  key hora.zmed                  as Zmed,
  key hora.zdia                  as Zdia,
      d.Nome,
      hora.zhora                 as Zhora,
      @Semantics.user.createdBy: true
      hora.created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      hora.created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      hora.last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      hora.last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      hora.local_last_changed_at as LocalLastChangedAt,

      _Nivel
}
