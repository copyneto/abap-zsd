@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Valor mínimo OV'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_FAT_VLR_MIN_OV
  as select from prcd_elements                                              as _Preco
    inner join   ZI_SD_CKPT_FAT_PARAMETROS( p_chave1 : 'ADM_FATURAMENTO',
                                                 p_chave2 : 'KSCHL_MINIMO') as _Param on  _Param.modulo    = 'SD'
                                                                                      and _Param.chave1    = 'ADM_FATURAMENTO'
                                                                                      and _Param.chave2    = 'KSCHL_MINIMO'
                                                                                      and _Param.chave3    = ''
                                                                                      and _Param.parametro = _Preco.kschl
{
  key _Preco.knumv                                              as SalesOrderCondition,
  key _Preco.kposn                                              as Item,
      cast(  coalesce( _Preco.kbetr , 0 ) as abap.dec( 24,2 ) ) as ElementAmount

}
