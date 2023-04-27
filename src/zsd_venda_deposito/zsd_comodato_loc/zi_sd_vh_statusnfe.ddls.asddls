@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help - Status NF-e'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_SD_VH_STATUSNFE
  as select from dd07t
  association [1..1] to I_BR_NFeDocumentStatus as _BR_NFeDocumentStatus on $projection.BR_NFeDocumentStatus = _BR_NFeDocumentStatus.BR_NFeDocumentStatus
  association [0..1] to I_Language             as _Language             on $projection.Language = _Language.Language
{
      @UI.hidden: true
      @Semantics.language
  key cast( ddlanguage as spras preserving type )                                  as Language,
      @ObjectModel.text.element: ['BR_NFeDocumentStatusDesc']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key cast( substring( domvalue_l, 1, 1 ) as  logbr_nfedocstatus preserving type ) as BR_NFeDocumentStatus,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      @Search.fuzzinessThreshold: 0.7
      ddtext                                                                       as BR_NFeDocumentStatusDesc,

      _BR_NFeDocumentStatus,
      _Language
}
where
      domname            = 'J_1BNFEDOCSTATUS'
  and as4local           = 'A'
  and _Language.Language = $session.system_language
//  and _BR_NFeDocumentStatus.BR_NFeDocumentStatus is not initial
