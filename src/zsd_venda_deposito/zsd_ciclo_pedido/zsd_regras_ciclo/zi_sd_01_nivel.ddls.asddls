@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Níveis de serviço desejados'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_01_NIVEL
  as select from ztsd_nivel_ser

  composition [0..*] of zi_sd_02_hora       as _Hora
  composition [0..*] of zi_sd_03_dia        as _Dia

  association [0..1] to ZI_SD_VH_MEDICAO    as _Medicao on _Medicao.zMed = $projection.Zmed
  association [0..1] to ZI_SD_VH_EVE_INICIO as _EveIni  on _EveIni.ZevenI = $projection.ZevenI
  association [0..1] to ZI_SD_VH_EVE_FIM    as _EveFim  on _EveFim.ZevenF = $projection.ZevenF
  association [0..1] to ZI_SD_VH_ITINERARIO as _Itiner  on _Itiner.Route = $projection.Ziti

{
  key  ziti                                as Ziti,
  key  zmed                                as Zmed,
       zeven_i                             as ZevenI,
       zeven_f                             as ZevenF,
       zprah                               as Zprah,
       concat( substring( zprah, 1, 2),
       concat( ':',
               substring( zprah, 3, 2) ) ) as ZprahConv,
       zprad                               as Zprad,
       zcale                               as Zcale,
       @Semantics.user.createdBy: true
       created_by                          as CreatedBy,
       @Semantics.systemDateTime.createdAt: true
       created_at                          as CreatedAt,
       @Semantics.user.lastChangedBy: true
       last_changed_by                     as LastChangedBy,
       @Semantics.systemDateTime.lastChangedAt: true
       last_changed_at                     as LastChangedAt,
       @Semantics.systemDateTime.localInstanceLastChangedAt: true
       local_last_changed_at               as LocalLastChangedAt,

       _Hora,
       _Dia,
       _Medicao,
       _EveIni,
       _EveFim,
       _Itiner
}
