@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca esquema de calculo'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COCKPIT_DEV_ESQUEMA_CALC
  as select from    vbrk                      as _DocFat
    inner join      ZI_SD_PARAM_TP_DOC_DEV    as _TpDoc       on _TpDoc.TpDoc = _DocFat.fkart
    inner join      ZI_SD_PARAM_TP_COND_PRECO as _EsquemaCalc on _EsquemaCalc.EsquemaCalc = _DocFat.kalsm
    inner join      vbrp                      as _DocFatItem  on _DocFatItem.vbeln = _DocFat.vbeln
    left outer join prcd_elements             as _Preco       on  _Preco.knumv = _DocFat.knumv
                                                              and _Preco.kposn = _DocFatItem.posnr
                                                              and _Preco.kschl = 'ZPR1'
    left outer join prcd_elements             as _Preco_lpp   on  _Preco_lpp.knumv = _DocFat.knumv
                                                              and _Preco_lpp.kposn = _DocFatItem.posnr
                                                              and _Preco_lpp.kschl = 'ZLPP'
{
  key _DocFat.vbeln     as DocFaturamento,
  key _DocFatItem.posnr as Item,
  
      case
      when _Preco.kbetr = 0
      then cast(  _Preco_lpp.kbetr as abap.dec( 24, 2 ) )
      else cast(  _Preco.kbetr as abap.dec( 24, 2 ) )
       end              as kbetr
}
