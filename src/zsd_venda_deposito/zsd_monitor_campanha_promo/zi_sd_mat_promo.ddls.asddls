@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface Mat. Campanha Promocional'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_MAT_PROMO as select from ztsd_mat_promo {
    key zmatnr as Zmatnr,
    key modelo as Modelo,
    @Semantics.quantity.unitOfMeasure: 'Zmeins'
    zmenge as Zmenge,
    zmeins as Zmeins,
    zloevm as Zloevm,
    zlgort as Zlgort,
    zcentro as Zcentro,
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
