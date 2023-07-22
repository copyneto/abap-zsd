@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Seleção Princing'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #L,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_FAT_PRECO
  as select from prcd_elements                                                 as _Preco
    inner join   ZI_SD_CKPT_FAT_PARAMETROS( p_chave1 : 'ADM_FATURAMENTO',
                                            p_chave2 : 'KSCHL_MINIMO_COMPARA') as _Param on  _Param.modulo    = 'SD'
                                                                                         and _Param.chave1    = 'ADM_FATURAMENTO'
                                                                                         and _Param.chave2    = 'KSCHL_MINIMO_COMPARA'
                                                                                         and _Param.chave3    = ''
                                                                                         and _Param.parametro = _Preco.kschl
{
  key  _Preco.knumv,
  key  _Preco.kposn,
  key  _Preco.stunr,
  key  _Preco.zaehk,
       _Preco.waerk,
       @Semantics.amount.currencyCode : 'waerk'
       _Preco.kwert

}
