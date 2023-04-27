@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interf - Direitos fiscais p/ Ordens Operações Especiais'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_DIREITOS_FISC_ATV as select from ztsd_dir_fis_atv {
    key shipfrom as Shipfrom,
    key auart as Auart,
    j_1btaxlw1 as J1btaxlw1,
    j_1btaxlw2 as J1btaxlw2,
    j_1btaxlw5 as J1btaxlw5,
    j_1btaxlw4 as J1btaxlw4,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt,
    local_last_changed_at as LocalLastChangedAt
}
