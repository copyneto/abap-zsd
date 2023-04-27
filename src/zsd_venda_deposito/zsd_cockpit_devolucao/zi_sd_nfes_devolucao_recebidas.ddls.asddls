@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Buscar NF-es de devolução recebidas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_NFES_DEVOLUCAO_RECEBIDAS
  as select from ZI_SD_NOTA_FISCAIS as _NotaFiscais
{
  key _NotaFiscais.Centro         as Centro,
  key _NotaFiscais.ChaveAcesso    as ChaveAcesso,
      _NotaFiscais.DtSaidaNfe     as DtSaidaNfe,
      _NotaFiscais.GuiOperacao    as GuiOperacao,
      _NotaFiscais.CnpjCliente    as CnpjCliente,
      _NotaFiscais.LocalNegocio   as LocalNegocio,
      _NotaFiscais.Empresa        as Empresa,
      _NotaFiscais.LocalNegCnpj   as LocalNegCnpj,
      _NotaFiscais.CnpjDest       as CnpjDest,
      _NotaFiscais.Nfe,
      _NotaFiscais.Serie,
      _NotaFiscais.DataEmissao,
      _NotaFiscais.Cliente,
      _NotaFiscais.NomeCliente,
      @Semantics.amount.currencyCode: 'CodMoeda'
      _NotaFiscais.ValorTotal     as ValorTotal,
      _NotaFiscais.CodMoeda       as CodMoeda,
      _NotaFiscais.DescriOperacao as DescriOperacao
} group by 
  _NotaFiscais.Centro,        
  _NotaFiscais.CnpjCliente,   
  _NotaFiscais.DtSaidaNfe,    
  _NotaFiscais.LocalNegocio, 
  _NotaFiscais.Empresa,       
  _NotaFiscais.LocalNegCnpj,  
  _NotaFiscais.CnpjDest,      
  _NotaFiscais.ChaveAcesso,   
  _NotaFiscais.Nfe,          
  _NotaFiscais.Serie,        
  _NotaFiscais.DataEmissao,  
  _NotaFiscais.Cliente,      
  _NotaFiscais.NomeCliente,  
  _NotaFiscais.ValorTotal,    
  _NotaFiscais.CodMoeda,      
  _NotaFiscais.DescriOperacao,
  _NotaFiscais.GuiOperacao   
