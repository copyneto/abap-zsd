@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Converte Quantitidade NF para Unidade Básica do Material'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CONVERT_QUANTITY_TO_UMB
  as select from I_BR_NFItem     as NFItem
    inner join   I_BR_NFDocument as NF         on NF.BR_NotaFiscal = NFItem.BR_NotaFiscal
  //*De unidade
    inner join   marm            as _UnidadeNF on  _UnidadeNF.matnr = NFItem.Material
                                               and _UnidadeNF.meinh = NFItem.BaseUnit
  //*Material
    inner join   I_Material      as _Material  on NFItem.Material = _Material.Material

  //*Para Unidade
  association [1..1] to marm as _UnidadeMedida   on  _UnidadeMedida.matnr = $projection.Material
                                                 and _UnidadeMedida.meinh = _Material.MaterialBaseUnit

  association [1..1] to marm as _UnidadeMedidaKg on  _UnidadeMedidaKg.matnr = $projection.Material
                                                 and _UnidadeMedidaKg.meinh = 'KG'

{
  key NFItem.BR_NotaFiscal                                                                                                                                                                                                                                      as NumeroDocumento,
  key NFItem.BR_NotaFiscalItem                                                                                                                                                                                                                                  as NumeroDocumentoItem,
      NFItem.Material                                                                                                                                                                                                                                           as Material,
      NFItem.BaseUnit                                                                                                                                                                                                                                           as UnidadeMedidaNF,
      fltp_to_dec(cast(NFItem.QuantityInBaseUnit as abap.fltp ) as abap.dec(15,3))                                                                                                                                                                              as QuantidadeNF,
      _Material.MaterialBaseUnit                                                                                                                                                                                                                                as MaterialBaseUnitUMB,
      fltp_to_dec((cast(NFItem.QuantityInBaseUnit as abap.fltp) * cast(_UnidadeNF.umrez as abap.fltp)) / cast(_UnidadeNF.umren as abap.fltp ) as abap.dec(15,3) )                                                                                               as ValorConvUMB,
      fltp_to_dec((cast(NFItem.QuantityInBaseUnit as abap.fltp) * cast(_UnidadeNF.umrez as abap.fltp)) / cast(_UnidadeNF.umren as abap.fltp) * ( cast(_UnidadeMedidaKg.umren as abap.fltp)   / cast(_UnidadeMedidaKg.umrez as abap.fltp ) ) as abap.dec(15,3) ) as ValorConvKg,
      _UnidadeMedida
}
