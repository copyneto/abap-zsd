@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Segmento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REL_FISCAL_SAIDA_SEG
  as select from marc as _DadosCentro
  association to cepc as _DadosMestre
    on  _DadosMestre.prctr = $projection.prctr
    //    and _DadosMestre.kokrs = 'SC01'
    and _DadosMestre.kokrs = 'AC3C'
{
  _DadosCentro.matnr,
  _DadosCentro.werks,
  _DadosCentro.prctr,
  _DadosMestre.segment
}
