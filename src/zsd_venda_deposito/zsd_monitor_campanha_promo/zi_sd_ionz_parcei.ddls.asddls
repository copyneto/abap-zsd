@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interf. Lista de parceiros para Ordens da campanha'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_IONZ_PARCEI
  as select from ztsd_ionz_parcei
{
  key cast( partn_role as abap.char( 2 ) ) as PartnRole,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CONVESAO_PARVW'
    cast( partn_role as abap.char( 2 ) ) as PartnRole1,
      //key partn_role            as PartnRole1,
      partn_numb                           as PartnNumb,
      @Semantics.user.createdBy: true
      created_by                           as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at                           as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by                      as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                      as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at                as LocalLastChangedAt


}
