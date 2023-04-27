@EndUserText.label: 'Projeção - Relatório de Imobilizados'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
//@Search.searchable: true
define root view entity ZC_SD_RELATORIO_IMOBILIZADOS
  as projection on ZI_SD_RELATORIO_IMOBILIZADOS
{
             @Consumption.filter.hidden: true
  key        ChaveConacatena,
             @EndUserText.label: 'Docnum Saída'
             @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_NFESAIDA', element: 'DocnumSaida' } } ]
  key        Docnum_Saida,
             @EndUserText.label: 'Item Docnum Saída'
  key        Item_Saida,
             @EndUserText.label: 'Docnum Entrada'
             @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_ca_vh_docnum_entrada', element: 'DocnumEntrada' } } ]
             Docnum,
             @EndUserText.label: 'Item Docnum Entrada'
             Item,
             @EndUserText.label: 'Tipo de Ativo'
             @ObjectModel.text.element: ['TipoAtivoTexto']
             //          @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocumentType', element: 'BillingDocumentType' } } ]
             @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_TIPO_FATURA', element: 'BillingDocumentType' } } ]
             TipoAtivo,
             @Consumption.filter.hidden: true
             @UI.hidden: true
             TipoAtivoTexto,
             @EndUserText.label: 'Local de Negócios'
             @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_BRANCH', element: 'BusinessPlace' } } ]
             LocalNegocios,
             Centro,
             @EndUserText.label: 'Nº Imobilizado'
             @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_ANLN1', element: 'Imobilizado' } } ]
             Imobilizado,
             Plaqueta,
             NCM,
             Cliente,
             @EndUserText.label: 'Nome do Cliente'
             @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_CUSTOMER', element: 'CustomerName' } } ]
             NomeCliente,
             @EndUserText.label: 'UF de Destino'
             UFDestino,
             Quantidade,
             Unidade,
             @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MATERIAL', element: 'Material' } } ]
             Material,
             @EndUserText.label: 'Descrição do Material'
             DescricaoMaterial,
             @EndUserText.label: 'CFOP de Saída'
             CFOPSaida,
             @EndUserText.label: 'Tipo Doc Faturamento'
             @ObjectModel.text.element: ['DescrDocFaturamentoTipo']
             DocFaturamentoTipo,
             @EndUserText.label: 'Descr Tipo Doc Faturamento'
             DescrDocFaturamentoTipo,
             @EndUserText.label: 'Doc Faturamento Saída'
             DocFaturamentoSaida,
             @EndUserText.label: 'Data de Lançamento NF Saída'
             @Consumption.filter: { selectionType: #INTERVAL, multipleSelections: false }
             DataSaida,
             @EndUserText.label: 'NFE de Saída'
             @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_NFESAIDA', element: 'NfeSaida' } } ]
             NFESaida,
             //          @Semantics.amount.currencyCode:'SalesDocumentCurrency'
             //          @Aggregation.default:#SUM
             @EndUserText.label: 'Valor de Saída'
             ValorSaida,
             //          @Semantics.amount.currencyCode:'SalesDocumentCurrency'
             //          @Aggregation.default:#SUM
             @EndUserText.label: 'Montante Básico'
             MontanteBasico,
             @EndUserText.label: 'Taxa de Saída'
             TaxaSaida,
             //          @Semantics.amount.currencyCode:'SalesDocumentCurrency'
             //          @Aggregation.default:#SUM
             @EndUserText.label: 'Valor ICMS de Saída'
             ValorICMSSaida,
             //          @Semantics.amount.currencyCode:'SalesDocumentCurrency'
             //          @Aggregation.default:#SUM
             @EndUserText.label: 'Base de Cálculo Saída'
             BaseCalcSaida,
             //          @Semantics.amount.currencyCode:'SalesDocumentCurrency'
             //          @Aggregation.default:#SUM
             @EndUserText.label: 'Outra Base de Cálculo Saída'
             OutraBaseSaida,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_Status_imob',
                                                   element: 'text'}}]             
             @EndUserText.label: 'Status'
             Status,
             StatusCriticality,
             @EndUserText.label: 'Dias'
             @Consumption.filter.hidden: true
             @UI.hidden: true
             dias,
             @EndUserText.label: 'Data Final'
             DataFinal,
             @EndUserText.label: 'Dias Atrasados'
             DiasAtrasados,
             @EndUserText.label: 'Dias Pendentes'
             DiasPendentes,
             @EndUserText.label: 'CFOP de Entrada'
             CFOPEntrada,
             @EndUserText.label: 'Doc Faturamento Entrada'
             DocFaturamentoEntrada,
             @EndUserText.label: 'Data Entrada'
             DataEntrada,
             //          DocnumEntrada,
             @EndUserText.label: 'NFE de Entrada'
             @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_ca_vh_docnum_entrada', element: 'NfeEntrada' } } ]
             NFEEntrada,
             //          @Semantics.amount.currencyCode:'SalesDocumentCurrency'
             //          @Aggregation.default:#SUM
             @EndUserText.label: 'Valor de Entrada'
             ValorEntrada,
             //          @Semantics.amount.currencyCode:'SalesDocumentCurrency'
             //          @Aggregation.default:#SUM
             @EndUserText.label: 'Montante Básico Entrada'
             MontanteBasicoEntrada,
             @EndUserText.label: 'Taxa de Entrada'
             TaxaEntrada,
             //          @Semantics.amount.currencyCode:'SalesDocumentCurrency'
             //          @Aggregation.default:#SUM
             @EndUserText.label: 'Valor ICMS Entrada'
             ValorICMSEntrada,
             //          @Semantics.amount.currencyCode:'SalesDocumentCurrency'
             //          @Aggregation.default:#SUM
             @EndUserText.label: 'Base Cálc Entrada'
             BaseCalcEntrada,
             //          @Semantics.amount.currencyCode:'SalesDocumentCurrency'
             //          @Aggregation.default:#SUM
             @EndUserText.label: 'Outra Base Entrada'
             OutraBaseEntrada,
             @Consumption.valueHelpDefinition: [{ entity: { name: 'I_SalesOrganization', element: 'SalesOrganization' } } ]
             @EndUserText.label: 'Organização de Vendas'
             OrgVendas,
             @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VTWEG', element: 'CanalDistrib' } } ]
             @EndUserText.label: 'Canal de Distribuição'
             CanalDistribuicao,
             @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_SPART', element: 'SetorAtividade' } } ]
             @EndUserText.label: 'Setor de Atividade'
             SetorAtividades,
             @EndUserText.label: 'Domicilio Fiscal'
             DomicilioFiscal,
             @EndUserText.label: 'Moeda'
             SalesDocumentCurrency,
             //          @ObjectModel.readOnly: true
             //          @ObjectModel.virtualElement: true
             //          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_RELATORIO_IMOBILIZADOS'
             //  virtual Status            : char20,
             //          @ObjectModel.readOnly: true
             //          @ObjectModel.virtualElement: true
             //          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_RELATORIO_IMOBILIZADOS'
             //  virtual StatusCriticality : char1
             @Consumption.filter.hidden: true
             @ObjectModel: { virtualElement: true,
             virtualElementCalculatedBy: 'zclsd_url_imobilizados' }
  virtual    URL_DocnumEntrada : eso_longtext,
             @Consumption.filter.hidden: true
             @ObjectModel: { virtualElement: true,
             virtualElementCalculatedBy: 'zclsd_url_imobilizados' }
  virtual    URL_DocnumSaida   : eso_longtext
}
