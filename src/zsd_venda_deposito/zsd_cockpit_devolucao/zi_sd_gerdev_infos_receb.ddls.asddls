@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Seleção de CDS''s para campos de Devoluções Recebidas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_GERDEV_INFOS_RECEB
  as select from ZI_SD_NFES_DEVOLUCAO_RECEBIDAS as _DevolucaoReceb
  //inner join ZI_SD_PARAM_DTSAIDA as _ParamDtSaida on _ParamDtSaida.DtSaida = _DevolucaoReceb.DtSaidaNfe
  association to ZI_SD_INFOS_NFES_DEVOLUC_RECEB as _InfoDevolucaoReceb on  _InfoDevolucaoReceb.GuiOperacao = _DevolucaoReceb.GuiOperacao
                                                                       and _InfoDevolucaoReceb.ChaveAcesso = _DevolucaoReceb.ChaveAcesso
{
  key _DevolucaoReceb.Centro            as Centro,
  key _DevolucaoReceb.ChaveAcesso       as ChaveAcesso,
  key min( _InfoDevolucaoReceb.Item )   as Item,
      _DevolucaoReceb.GuiOperacao       as GuiOperacao,
//      _DevolucaoReceb.CnpjCliente       as CnpjCliente,
//      _DevolucaoReceb.DtSaidaNfe        as DataSaidaNFE,
      _InfoDevolucaoReceb.CodMoeda      as CodMoeda,
      @Semantics.amount.currencyCode: 'CodMoeda'
      _InfoDevolucaoReceb.ValorNota     as ValorTotalNota
//      _InfoDevolucaoReceb.CodEan        as CodigoEAN,
//      _InfoDevolucaoReceb.Quantidade    as Quantidade,
//      _InfoDevolucaoReceb.UnidMedida    as UnidadeMedida,
//      @Semantics.amount.currencyCode: 'CodMoeda'
//      _InfoDevolucaoReceb.ValorUnit     as ValorUnitario,
//      _InfoDevolucaoReceb.NaturOperacao as NaturezaOperac

}
group by
  _DevolucaoReceb.Centro,
  _DevolucaoReceb.ChaveAcesso,
  _DevolucaoReceb.GuiOperacao,
//  _DevolucaoReceb.CnpjCliente,
//  _DevolucaoReceb.DtSaidaNfe,
  _InfoDevolucaoReceb.CodMoeda,
  _InfoDevolucaoReceb.ValorNota
//  _InfoDevolucaoReceb.CodEan,
//  _InfoDevolucaoReceb.Quantidade,
//  _InfoDevolucaoReceb.UnidMedida,
//  _InfoDevolucaoReceb.ValorUnit,
//  _InfoDevolucaoReceb.NaturOperacao
