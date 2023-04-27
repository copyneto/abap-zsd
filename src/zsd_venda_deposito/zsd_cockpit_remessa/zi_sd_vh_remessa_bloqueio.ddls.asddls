@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Bloqueio de remessa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
//@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_SD_VH_REMESSA_BLOQUEIO
  as select from tvls  as DeliveryBlock
    inner join   tvlst as _Text on  _Text.lifsp = DeliveryBlock.lifsp
                                and _Text.spras = $session.system_language
{
      @ObjectModel.text.element: ['DeliveryBlockReasonText']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key DeliveryBlock.lifsp as DeliveryBlockReason,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Text.vtext         as DeliveryBlockReasonText
}
