@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help Tipo de Avaliação'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@UI.presentationVariant: [{ sortOrder: [ { by: 'Bwtar', direction: #DESC } ] } ]
define view entity ZI_SD_RELEX_VH_BWTAR
  as select from I_BR_NFItem
  association [0..1] to t149d as _T149D on _T149D.bwtar = $projection.Bwtar
{
  key ValuationType as Bwtar,
      _T149D.kkref  as KKREF,
      _T149D.bsext  as BSEXT,
      _T149D.bsint  as BSINT

}
where
  ValuationType is not initial
group by
  ValuationType,
  _T149D.kkref,
  _T149D.bsext,
  _T149D.bsint
