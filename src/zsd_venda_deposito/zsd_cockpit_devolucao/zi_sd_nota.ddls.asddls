@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface cabeçalho devolução'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_NOTA
  as select from /xnfe/innfehd as _NfeInbound
  //    inner join   ZI_SD_NFE_DEVOLUCAO_CANCEL as _NfeCancel on _NfeCancel.ChaveAcesso = _NfeInbound.nfeid
  association to /xnfe/innfeit as _NfeItem on _NfeItem.guid_header = $projection.GuiOperacao
{
  key _NfeInbound.guid_header as GuiOperacao,
  key _NfeInbound.nfeid       as ChaveAcesso,
  key _NfeItem.nitem          as Item,
      _NfeInbound.waers       as CodMoeda,
      @Semantics.amount.currencyCode: 'CodMoeda'
      _NfeInbound.s1_vnf      as ValorNota,
      _NfeInbound.natop       as NaturOperacao,
      _NfeItem.nitem          as IdItem,
      _NfeItem.cprod          as Material,
      _NfeItem.xprod          as TextoMaterial,
      _NfeItem.cean           as CodEan,
      _NfeItem.qcom           as Quantidade,
      _NfeItem.ucom           as UnidMedida,
      @Semantics.amount.currencyCode: 'CodMoeda'
      _NfeItem.vprod          as ValorUnit
}
