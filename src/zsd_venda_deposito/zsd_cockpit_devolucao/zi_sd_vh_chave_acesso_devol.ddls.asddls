@AbapCatalog.sqlViewName: 'ZVSD_CVACESSODEV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Chave Acesso Devolução'
//@Search.searchable: true
define view ZI_SD_VH_CHAVE_ACESSO_DEVOL

  as select from ZI_SD_CHAVE_ACESSO_NF_3C as _Nfe3C

{
          @UI.hidden: true
  key     SearchHelp,
          @EndUserText.label: 'Chave de Acesso'
  key     ChaveAcesso2         as ChaveAcesso,
          @Consumption.filter.mandatory: true
          //       //       @Search.defaultSearchElement: true
  key     Centro2              as Centro,

          //       //       @Search.defaultSearchElement: true
          @EndUserText.label: 'Nf-e'
  key     Nfe2                 as Nfe,
          //       @Search.defaultSearchElement: true
          @EndUserText.label: 'Série'
          Serie2               as Serie,
          //       @Search.defaultSearchElement: true
          @EndUserText.label: 'Nº documento'
          Docnum,
          //       @Search.defaultSearchElement: true
          @EndUserText.label: 'Total da NFe'
          ValorTotal2          as ValorTotal,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'Moeda'
          Moeda2               as Moeda,
          //       @Search.defaultSearchElement: true
          @EndUserText.label: 'Data de Emissão'
          DataEmissao2         as DataEmissao,
          //       @Search.defaultSearchElement: true
          @EndUserText.label: 'CNPJ'
          Cnpj2                as Cnpj,
          //       @Search.defaultSearchElement: true
          @EndUserText.label: 'Cliente'
          Cliente2             as Cliente,
          //       @Search.defaultSearchElement: true
          @EndUserText.label: 'Nome Cliente'
          NomeCliente2         as NomeCliente,
          @Consumption.filter.mandatory: true
          //       @Search.defaultSearchElement: true
          @ObjectModel.text.element:['TipoDevText']
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_ENABLE_NFE',element: 'TipoDev' }}]
          TpDevolucao2         as TpDevolucao,
          //       @Search.defaultSearchElement: true
          @UI.hidden: true
          'Retorno da Empresa' as TipoDevText

}
group by
  SearchHelp,
  Docnum,
  Nfe2,
  Serie2,
  Centro2,
  Cnpj2,
  Moeda2,
  ValorTotal2,
  DataEmissao2,
  Cliente2,
  NomeCliente2,
  TpDevolucao2,
  ChaveAcesso2

union select from ZI_SD_CHAVE_ACESSO_NF_3C3 as _Nfe3C_3
{
          @UI.hidden: true
  key     SearchHelp,
          @EndUserText.label: 'Chave de Acesso'
  key     ChaveAcesso,
          @Consumption.filter.mandatory: true
          //       @Search.defaultSearchElement: true
  key     Centro,

          //       @Search.defaultSearchElement: true
          @EndUserText.label: 'Nf-e'
  key     Nfe,
          //       @Search.defaultSearchElement: true
          @EndUserText.label: 'Série'
          Serie,
          //       @Search.defaultSearchElement: true
          @EndUserText.label: 'Nº documento'
          Docnum,
          //       @Search.defaultSearchElement: true
          @EndUserText.label: 'Total da NFe'
          ValorTotal,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'Moeda'
          Moeda,
          //       @Search.defaultSearchElement: true
          @EndUserText.label: 'Data de Emissão'
          DataEmissao,
          //       @Search.defaultSearchElement: true
          @EndUserText.label: 'CNPJ'
          Cnpj,
          //       @Search.defaultSearchElement: true
          @EndUserText.label: 'Cliente'
          Cliente,
          //       @Search.defaultSearchElement: true
          @EndUserText.label: 'Nome Cliente'
          NomeCliente,
          @Consumption.filter.mandatory: true
          //       @Search.defaultSearchElement: true
          @ObjectModel.text.element:['TipoDevText']
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_ENABLE_NFE',element: 'TipoDev' }}]
          TpDevolucao,
          //       @Search.defaultSearchElement: true
          @UI.hidden: true
          'Devolução E-Commerce B2C' as TipoDevText
}
group by
  SearchHelp,
  Docnum,
  Nfe,
  Serie,
  Centro,
  Cnpj,
  Moeda,
  ValorTotal,
  DataEmissao,
  Cliente,
  NomeCliente,
  TpDevolucao,
  ChaveAcesso

union select from ZI_SD_CHAVE_ACESSO_NF_CLIENTE as _Nfe3Cliente
{
         @UI.hidden: true
  key    SearchHelp,
         @EndUserText.label: 'Chave de Acesso'
  key    ChaveAcesso,
         @Consumption.filter.mandatory: true
         //       @Search.defaultSearchElement: true
  key    Centro,
         //       @Search.defaultSearchElement: true
         @EndUserText.label: 'Nf-e'
  key    Nfe,
         //       @Search.defaultSearchElement: true
         @EndUserText.label: 'Série'
         Serie,
         //       @Search.defaultSearchElement: true
         @EndUserText.label: 'Nº documento'
         Docnum,
         //       @Search.defaultSearchElement: true
         @EndUserText.label: 'Total da NFe'
         ValorTotal,
         @Consumption.filter.hidden: true
         @EndUserText.label: 'Moeda'
         Moeda,
         //       @Search.defaultSearchElement: true
         @EndUserText.label: 'Data de Emissão'
         DataEmissao,
         //       @Search.defaultSearchElement: true
         @EndUserText.label: 'CNPJ'
         Cnpj,
         //       @Search.defaultSearchElement: true
         @EndUserText.label: 'Cliente'
         Cliente,
         //       @Search.defaultSearchElement: true
         @EndUserText.label: 'Nome Cliente'
         NomeCliente,
         @Consumption.filter.mandatory: true
         //       @Search.defaultSearchElement: true
         @ObjectModel.text.element:['TipoDevText']
         @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_ENABLE_NFE',element: 'TipoDev' }}]
         TpDevolucao,
         //       @Search.defaultSearchElement: true
         @UI.hidden: true
         'Nf-e emitida pelo Cliente' as TipoDevText
}
where
  _Nfe3Cliente.Cancelada is null
group by
  SearchHelp,
  Docnum,
  Nfe,
  Serie,
  Centro,
  Cnpj,
  Moeda,
  ValorTotal,
  DataEmissao,
  Cliente,
  NomeCliente,
  TpDevolucao,
  ChaveAcesso
