@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Doc fat. search help Cockpit Devolução'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COCKPIT_DEVOL_FAT_RET
  as select from    vbrp                          as _DocFatItem

    left outer join ZI_SD_CKPT_DEV_VLR_ORDEM_RET  as _DocFatRet on  _DocFatRet.vbeln = _DocFatItem.vbeln
                                                                and _DocFatRet.posnr = _DocFatItem.posnr

    left outer join ZI_SD_CKPT_DEV_CALC_VLR_ORDEM as _DocFatUti on  _DocFatUti.vbeln = _DocFatItem.vbeln
                                                                and _DocFatUti.posnr = _DocFatItem.posnr

  //    left outer join vbfa                          as _DocFatDev on  _DocFatDev.vbelv   = _DocFatItem.vbeln
  //                                                                and _DocFatDev.posnv   = _DocFatItem.posnr
  //                                                                and _DocFatDev.vbtyp_v = 'M'
  //                                                                and _DocFatDev.vbtyp_n = 'H'
  //
  //    left outer join vbap                          as _OrdemDev  on  _OrdemDev.vbeln = _DocFatDev.vbeln
  //                                                                and _OrdemDev.posnr = _DocFatDev.posnn

{
  key   _DocFatItem.vbeln,
  key   _DocFatItem.posnr,
        //        _DocFatDev.vbtyp_n,
        //        _OrdemDev.absta,
        //        cast( _DocFatItem.fkimg as abap.dec( 13, 3 )) -  cast( _DocFatDev.rfmng as abap.dec( 13, 3 )) as Quantidade,
        //
        //        case
        //        when _OrdemDev.absta = 'C'
        //        then cast(  _DocFatItem.fkimg as abap.dec( 13, 3 ))
        //        else
        //        cast( _DocFatItem.fkimg as abap.dec( 13, 3 )) -  cast( _DocFatDev.rfmng as abap.dec( 13, 3 ))
        //        end                                                                                           as QuantidadePendente
        
        case
        when _DocFatRet.vbeln is not initial and _DocFatUti.vbeln is initial
        then 'C'
        else ' '
        end                                                                   as absta,

        cast( _DocFatItem.fkimg as abap.dec( 13, 3 )) - _DocFatUti.Quantidade as Quantidade,

        case
        when _DocFatRet.vbeln is not initial and _DocFatUti.vbeln is initial
        then cast(  _DocFatItem.fkimg as abap.dec( 13, 3 ))
        else
        cast( _DocFatItem.fkimg as abap.dec( 13, 3 )) -  _DocFatUti.Quantidade
        end                                                                   as QuantidadePendente

}
