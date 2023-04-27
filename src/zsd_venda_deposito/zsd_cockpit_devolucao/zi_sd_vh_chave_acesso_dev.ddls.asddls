@AbapCatalog.sqlViewName: 'ZISD_CVACESSODEV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Chave Acesso Devolução'
@Search.searchable: true
define view ZI_SD_VH_CHAVE_ACESSO_DEV
  as select from    ZI_SD_NFES_DEVOLUCAO_RECEBIDAS as _NfeDevolucao
    left outer join ZI_SD_COCKPIT_DEVOLUCAO        as _Devolucao on _Devolucao.ChaveAcesso = _NfeDevolucao.ChaveAcesso

{
       @Consumption.filter.mandatory: true
       @Search.defaultSearchElement: true
  key  _NfeDevolucao.Centro      as Centro,
       @Consumption.filter.mandatory: true
       @Search.defaultSearchElement: true
       @EndUserText.label: 'CNPJ'
  key  _NfeDevolucao.CnpjCliente as Cnpj,
       @Search.defaultSearchElement: true
       @EndUserText.label: 'Data Saída Nf-e'
  key  _NfeDevolucao.DtSaidaNfe  as DtSaidaNfe,
       @Search.defaultSearchElement: true
  key  _NfeDevolucao.ChaveAcesso as ChaveAcesso,
       @Search.defaultSearchElement: true
       @EndUserText.label: 'Cliente'
  key  _NfeDevolucao.Cliente,
       @EndUserText.label: 'Nome do cliente'
       @Consumption.filter.hidden: true
       _NfeDevolucao.NomeCliente,
       @EndUserText.label: 'Nf-e'
       @Search.defaultSearchElement: true
       @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_NFENUM', element: 'nfenum' }}]
       _NfeDevolucao.Nfe,
       @EndUserText.label: 'Série'
       @Search.defaultSearchElement: true
       _NfeDevolucao.Serie,
       @Search.defaultSearchElement: true
       @Semantics.amount.currencyCode: 'CodMoeda'
       @EndUserText.label: 'Total da NFe'
       _NfeDevolucao.ValorTotal,
       @Consumption.filter.hidden: true
       @EndUserText.label: 'Moeda'
       _NfeDevolucao.CodMoeda,
       @Search.defaultSearchElement: true
       @EndUserText.label: 'Data de Emissão'
       _NfeDevolucao.DataEmissao
       //       substring( _NfeDevolucao.ChaveAcesso, 26, 9) as nfenum

}
where
      _Devolucao.ChaveAcesso is null
  and _NfeDevolucao.Nfe      <> '00000000'
group by
  _NfeDevolucao.Centro,
  _NfeDevolucao.CnpjCliente,
  _NfeDevolucao.DtSaidaNfe,
  _NfeDevolucao.ChaveAcesso,
  _NfeDevolucao.Nfe,
  _NfeDevolucao.Serie,
  _NfeDevolucao.ValorTotal,
  _NfeDevolucao.CodMoeda,
  _NfeDevolucao.DataEmissao,
  _NfeDevolucao.Cliente,
  _NfeDevolucao.NomeCliente
