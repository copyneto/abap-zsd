@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search help Status Recusa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
@Analytics.dataExtraction.enabled: true

define view entity ZI_SD_VH_STATUS_PEDIDO_RECUSA
  as select from tvbst                          as _Doc
    inner join   I_OverallSDDocumentRjcnStatusT as _OverallSDDocumentRejectionSts on  _OverallSDDocumentRejectionSts.OverallSDDocumentRejectionSts = _Doc.statu
                                                                                  and _OverallSDDocumentRejectionSts.Language                      = $session.system_language
{

  key _Doc.statu as OverallSDDocumentRejectionSts,

      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.9
      _Doc.bezei as OvrlSDDocumentRejectionStsDesc

}
where
  (
      _Doc.tbnam = 'VBAK'
  )
  and(
      _Doc.fdnam = 'ABSTK'
  )
  and _Doc.spras = $session.system_language
