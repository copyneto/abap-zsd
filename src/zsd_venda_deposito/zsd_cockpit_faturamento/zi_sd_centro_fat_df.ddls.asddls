@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'De-Para’s dos centros faturamento/Centros depósito fechado'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #C,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_CENTRO_FAT_DF
  as select from ztsd_centrofatdf
{
        @EndUserText.label: 'Centro Faturamento'
  key   centrofaturamento     as CentroFaturamento,
        @EndUserText.label: 'Centro Depósito Fechado'
  key   centrodepfechado      as CentroDepFechado,
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
