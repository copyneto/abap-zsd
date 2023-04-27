@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Conta'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REL_FISCAL_SAIDA_FLUXO
  as select from vbrp as _VBRP
    inner join   vbfa as _VBFA
      on  _VBFA.vbelv   = _VBRP.vgbel
      and _VBFA.posnv   = _VBRP.vgpos
      and _VBFA.vbtyp_n = 'R'
      and _VBFA.bwart <> '657'
//      and _VBFA.bwart <> 'Z05'
{
  key _VBRP.vbeln,
  key _VBRP.posnr,
      _VBRP.vgbel,
      _VBRP.vgpos,
      _VBFA.posnn,
      min(_VBFA.vbeln)                                   as MaterialDocument,
      cast( right( _VBFA.posnn, 4 ) as nsdm_mblpo ) as MaterialDocumentItem

}
group by
    _VBRP.vbeln,
    _VBRP.posnr,
    _VBRP.vgbel,
    _VBRP.vgpos,
    _VBFA.posnn
