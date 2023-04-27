@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Seleção de CDS''s para captação do campo Total NF'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_INFOS_NFTOTAL
  as select from ZI_SD_NFES_DEVOLUCAO_RECEBIDAS as _DevolucaoReceb
  //    inner join ZI_SD_PARAM_DTSAIDA as _ParamDtSaida on _ParamDtSaida.DtSaida = _DevolucaoReceb.DtSaidaNfe
//  association to ZI_SD_INFOS_NFES_DEVOLUC_RECEB as _InfoDevolucaoReceb on  _InfoDevolucaoReceb.GuiOperacao = _DevolucaoReceb.GuiOperacao
//                                                                       and _InfoDevolucaoReceb.ChaveAcesso = _DevolucaoReceb.ChaveAcesso
{
  key _DevolucaoReceb.CnpjCliente as CNPJCliente,
  key _DevolucaoReceb.Centro      as Centro,
      _DevolucaoReceb.DtSaidaNfe  as DataSaidaNFE,
      _DevolucaoReceb.Nfe,
      _DevolucaoReceb.Serie,
      //        _InfoDevolucaoReceb.CodMoeda as CodMoeda,
      //        @Semantics.amount.currencyCode: 'CodMoeda'
      //        _InfoDevolucaoReceb.ValorNota as ValorTotalNota
      _DevolucaoReceb.CodMoeda    as CodMoeda,
      @Semantics.amount.currencyCode: 'CodMoeda'
      _DevolucaoReceb.ValorTotal  as ValorTotalNota
//      _InfoDevolucaoReceb
}
