@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Desconto Incondicional'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REL_FISCAL_SAIDA_INCOD
  with parameters
    p_cond : kscha
  as select from vbrk          as _vbrk
    inner join   prcd_elements as _PRCD_ELEMENTS on _PRCD_ELEMENTS.knumv = _vbrk.knumv

{

  key _vbrk.vbeln,
  key _PRCD_ELEMENTS.kposn                                 as Kposn,
      cast(_PRCD_ELEMENTS.kwert as logbr_invoicenetamount) as valorCond

}
where
  _PRCD_ELEMENTS.kschl = $parameters.p_cond
