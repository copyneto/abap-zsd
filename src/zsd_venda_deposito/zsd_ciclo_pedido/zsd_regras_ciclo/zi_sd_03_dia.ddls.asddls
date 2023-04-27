@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dias de Faturamento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_sd_03_dia
  as select from ztsd_dia_fat  as Dia
    inner join   ZC_SD_VH_DIAE as d on d.Dias = Dia.zdia
  association to parent ZI_SD_01_NIVEL as _Nivel on  $projection.Ziti = _Nivel.Ziti
                                                 and $projection.Zmed = _Nivel.Zmed
{
  key Dia.ziti                  as Ziti,
  key Dia.zmed                  as Zmed,
  key Dia.zdia                  as Zdia,
      d.Nome,
      @Semantics.user.createdBy: true
      Dia.created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      Dia.created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      Dia.last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      Dia.last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      Dia.local_last_changed_at as LocalLastChangedAt,

      _Nivel
}
