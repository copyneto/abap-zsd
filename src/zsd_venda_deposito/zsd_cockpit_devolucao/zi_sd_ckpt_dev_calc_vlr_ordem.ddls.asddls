@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Doc fat. search help Cockpit Devolução'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_DEV_CALC_VLR_ORDEM
  as select from    vbrp as _DocFatItem

    left outer join vbfa as _DocFatDev on  _DocFatDev.vbelv   = _DocFatItem.vbeln
                                       and _DocFatDev.posnv   = _DocFatItem.posnr
                                       and _DocFatDev.vbtyp_v = 'M'
                                       and _DocFatDev.vbtyp_n = 'H'

    left outer join vbap as _OrdemDev  on  _OrdemDev.vbeln = _DocFatDev.vbeln
                                       and _OrdemDev.posnr = _DocFatDev.posnn

{
  key    _DocFatItem.vbeln,
  key    _DocFatItem.posnr,
         sum( cast( _DocFatDev.rfmng as abap.dec( 13, 3 )) ) as Quantidade

}
where
  _OrdemDev.absta <> 'C'
group by
  _DocFatItem.vbeln,
  _DocFatItem.posnr
