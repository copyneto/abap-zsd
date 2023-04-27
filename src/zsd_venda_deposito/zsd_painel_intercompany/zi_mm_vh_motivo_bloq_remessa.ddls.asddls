@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Motivo de Bloqueio'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_MM_VH_MOTIVO_BLOQ_REMESSA
  as select from tvls
  association [0..1] to I_DeliveryBlockReasonText as _Text on  _Text.DeliveryBlockReason = $projection.DeliveryBlockReason
                                                           and _Text.Language            = $session.system_language
{
      @ObjectModel.text.element: ['DeliveryBlockReasonText']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key lifsp as DeliveryBlockReason,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      _Text.DeliveryBlockReasonText
}
