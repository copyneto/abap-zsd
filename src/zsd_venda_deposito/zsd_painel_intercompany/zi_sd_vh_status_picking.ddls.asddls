@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Status do Picking'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_SD_VH_STATUS_PICKING
  as select from tvbst
    inner join   dd07l                        as _Domain on _Domain.domvalue_l = tvbst.statu

//    inner join   I_OverallSDProcessStatusText as _Text   on  _Text.OverallSDProcessStatus = tvbst.statu
//                                                         and _Text.Language               = $session.system_language
{
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key tvbst.statu as OverallSDProcessStatus,

      @Search.ranking: #HIGH
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Semantics.text: true
      tvbst.bezei as OverallSDProcessStatusDesc
}
where
  (
      tvbst.tbnam      = 'VBAK'
  )
  and(
      tvbst.fdnam      = 'GBSTK'
  )
  and(
      tvbst.spras      = $session.system_language
  )
  and(
    (
      _Domain.domname  = 'STATV'
    )
    and(
      _Domain.as4local = 'A'
    )
  )
