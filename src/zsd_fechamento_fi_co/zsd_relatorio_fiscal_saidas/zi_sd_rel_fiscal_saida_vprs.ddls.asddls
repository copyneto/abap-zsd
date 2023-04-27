@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Busca VPRS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REL_FISCAL_SAIDA_VPRS
  as select from lips as _lips
  inner join likp as _likp on _likp.vbeln = _lips.vbeln
  inner join prcd_elements as  _prcdelements on _prcdelements.knumv = _likp.knump
                                            and _prcdelements.kposn = _lips.posnr
                                            and _prcdelements.kschl = 'VPRS'
{
  key _lips.vbeln,
  key _lips.posnr,
      _lips.matnr,
      _lips.werks,
      _likp.knump,
    sum(_prcdelements.kbetr) as VlUnitario,
    sum(cast(_prcdelements.kwert as abap.dec( 15, 2 ))) as VlTotal
}
group by
    _lips.vbeln,
    _lips.posnr,
    _lips.matnr,
    _lips.werks,
    _likp.knump
