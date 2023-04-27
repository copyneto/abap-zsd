@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca Condição válida'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_ATUAL_VIG_KONP
  as select from zi_sd_atualizar_vigencia_preco as I_Vigencia
    inner join   konp                           as _Monto on I_Vigencia.knumh = _Monto.knumh
{

  key    I_Vigencia.vtweg,
  key    I_Vigencia.pltyp,
  key    I_Vigencia.werks,
  key    I_Vigencia.matnr,
  key    I_Vigencia.datbi,
  key
  case
  when I_Vigencia.datbi < '31129999'and _Monto.loevm_ko  = 'X'
  then _Monto.knumh
  when _Monto.loevm_ko = ' '
  then _Monto.knumh
  else ' '
  end as knumh,
  @Semantics.quantity.unitOfMeasure : 'kmein'
  _Monto.kstbm,
  _Monto.konwa,
  @Semantics.amount.currencyCode : 'konwa'
  _Monto.mxwrt,
  @Semantics.amount.currencyCode : 'konwa'
  _Monto.gkwrt,
  @Semantics.amount.currencyCode : 'konwa'
  _Monto.kbetr,
  _Monto.kmein,
  _Monto.loevm_ko

}
