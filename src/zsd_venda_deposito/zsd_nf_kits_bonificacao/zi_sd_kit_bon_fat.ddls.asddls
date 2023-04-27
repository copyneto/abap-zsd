@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca Fatura'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_KIT_BON_FAT
  as select from vbrp as _DocFaturamentoItem
    inner join   vbrk as _DocFaturamento on  _DocFaturamento.vbeln = _DocFaturamentoItem.vbeln
                                         and _DocFaturamento.vf_status != 'C'
                                         and _DocFaturamento.vbtyp = 'M'
{
  key _DocFaturamentoItem.vbeln as SubsequentDocument,
  key _DocFaturamentoItem.posnr as Item,
      _DocFaturamentoItem.vgbel as Ordem
}
--where
  --_DocFaturamentoItem.posnr = '000010'
