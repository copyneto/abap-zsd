@EndUserText.label: 'Comodato e locação - Cockpit Contratos'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define root view entity ZC_SD_COCKPIT_APP
  as projection on ZI_SD_COCKPIT_APP
  association [0..*] to ZC_SD_INF_DISTRATO          as _Distrato    on _Distrato.Contrato = $projection.SalesContract
  association [0..*] to ZC_SD_LOC_EQUIP             as _LocEquip    on _LocEquip.Contrato = $projection.SalesContract
  association [0..*] to ZC_SD_CR_CP                 as _AnaliseCRCP on _AnaliseCRCP.Contrato = $projection.SalesContract
  association [0..*] to ZC_SD_DET_JOBS              as _DetalheJob  on _DetalheJob.Contrato = $projection.SalesContract
  association [0..*] to ZC_SD_COMODATO_POPUP_CENTRO as _PopCentro   on _PopCentro.werks_dest = $projection.werks_dest
{
          @EndUserText.label: 'Contrato'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_CONTRATO', element: 'SalesContract' }}]
  key     SalesContract,
          @EndUserText.label: 'Solicitação'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_PurchaseOrderCustomer', element: 'PurchaseOrderByCustomer' } }]
  key     Solicitacao,
          @EndUserText.label: 'Ordem de Venda'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_ORDEM', element: 'SalesOrder' } }]
          OrdemVenda,
          @EndUserText.label: 'Fatura'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocumentStdVH', element: 'BillingDocument' } }]
          DocFatura,
          @EndUserText.label: 'Centro Destino'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PlantStdVH', element: 'Plant' } }]
          @ObjectModel.text.element: ['CentroDestinoName']
          CentroDestino,
          @EndUserText.label: 'Remessa'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'I_DeliveryDocumentStdVH', element: 'DeliveryDocument' } }]
          Remessa,
          @EndUserText.label: 'CR/CP'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_CRCP', element: 'Id' } }]
          CrCp,
          @EndUserText.label: 'Data Criação'
          @Consumption.filter.selectionType: #INTERVAL
          DataCriacaoContrato,
          @EndUserText.label: 'Tipo do Contrato'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_TIPO_CTR', element: 'TipoId' } }]
          @ObjectModel.text.element: ['TipoContratoTexto']
          @UI.textArrangement: #TEXT_LAST
          TipoContrato,
          @UI.hidden: true
          TipoContratoTexto,
          @EndUserText.label: 'Centro Origem'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PlantStdVH', element: 'Plant' } }]
          @ObjectModel.text.element: ['CentroOrigemName']
          CentroOrigem,
          @UI.hidden: true
          CentroOrigemName,
          @UI.hidden: true
          CentroDestinoName,
          @EndUserText.label: 'Emissor da Ordem'
          @ObjectModel.text.element: ['EmissorName']
          EmissorOrdem,
          @UI.hidden: true
          EmissorName,
          @EndUserText.label: 'Status Ordem de Venda'
          OrdemVendaStatus,
          @UI.hidden: true
          OrdemVendaCriticality,
          @EndUserText.label: 'Tipo Ordem de Venda'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_AUART', element: 'SalesDocumentType' } }]
          @ObjectModel.text.element: ['TpOrdemVendaText']
          @UI.textArrangement: #TEXT_LAST
          TipoOrdemVenda,
          TpOrdemVendaText,
          @EndUserText.label: 'Status Remessa'
          RemessaStatus,
          @UI.hidden: true
          RemessaCriticality,
          @EndUserText.label: 'Ordem de Frete'
          OrdemFrete,
          @EndUserText.label: 'Status Ordem de Frete'
          OrdemFreteStatus,
          @UI.hidden: true
          OrdemFreteCriticality,
          @EndUserText.label: 'Status Fatura'
          DocFaturaStatus,
          @UI.hidden: true
          DocFaturaCriticality,
          @EndUserText.label: 'Status da NF-e'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_STATUSNFE', element: 'BR_NFeDocumentStatus' } }]
          StatusNfe,
          @EndUserText.label: 'NF-e Saída'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_ca_vh_docnum_saida', element: 'DocnumSaida' } }]
          NfeSaida,
          @EndUserText.label: 'Tipo de operação'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_TIPO_OP', element: 'TipoOperacao' } }]
          TpOperacao,
          @EndUserText.label: 'Status do contrato'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_STATUS_CTR', element: 'StatusId' } }]
          @ObjectModel.text.element: ['StatusTxt']
          Status,
          @UI.hidden: true
          StatusTxt,
          @UI.hidden: true
          StatusContratoCriticality,
          @EndUserText.label: 'Documento Saída'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_ca_vh_docnum_saida', element: 'DocnumSaida' } }]
          DocnumNfeSaida,
          @EndUserText.label: 'Status Doc. Saída'
          DocnumNfeSaidaStatus,
          @UI.hidden: true
          DocnumNfeSaidaCriticality,
          @EndUserText.label: 'Documento Entrada'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'zi_ca_vh_docnum_entrada', element: 'DocnumEntrada' } }]
          DocnumEntrada,
//          @EndUserText.label: 'Documento Reinscidido'
//          DocnumReins,
          @EndUserText.label: 'Status Doc. Entrada'
          DocnumEntradaStatus,
          @UI.hidden: true
          DocnumEntradaCriticality,
          @EndUserText.label: 'Contas a Pagar'
          StatusCP,
          @EndUserText.label: 'Status Contas a Pagar'
          StatusCPStatus,
          @UI.hidden: true
          StatusCPCriticality,
          @EndUserText.label: 'Contrato'
          ContratoLog,
          @EndUserText.label: 'Solicitação Fluig'
          SolicitacaoLog,
          @EndUserText.label: 'Documento Saída'
          DocnumNfeSaidaLog,
          @EndUserText.label: 'NF'
          NfeSaidaLog,
          @EndUserText.label: 'Ordem de Frete'
          OrdemFreteLog,
          @EndUserText.label: 'Log de Status'
          StatusLog,

          @EndUserText.label: 'Valor da Locação'
          @Semantics.amount.currencyCode : 'waerk'
          ValorLoc,

          waerk,

          @EndUserText.label: 'Qtde. Itens Atual'
          QtdeAtual,
          @EndUserText.label: 'Qtde. Itens Total'
          QtdeTotal,
          @EndUserText.label: 'Confirma Entrada de Mercadorias?'
          EntradaMercadorias,
          werks_dest,

          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLSD_URL_CONTRACT' }
  virtual URL_VA43    : eso_longtext,
          @ObjectModel: { virtualElement: true,
                        virtualElementCalculatedBy: 'ABAP:ZCLSD_URL_CONTRACT' }
  virtual URL_SAIDA   : eso_longtext,
          @ObjectModel: { virtualElement: true,
                        virtualElementCalculatedBy: 'ABAP:ZCLSD_URL_CONTRACT' }
  virtual URL_ENTRAD  : eso_longtext,
          @ObjectModel: { virtualElement: true,
                        virtualElementCalculatedBy: 'ABAP:ZCLSD_URL_CONTRACT' }
  virtual URL_ORVEN   : eso_longtext,
          @ObjectModel: { virtualElement: true,
                      virtualElementCalculatedBy: 'ABAP:ZCLSD_URL_CONTRACT' }
  virtual URL_REMES   : eso_longtext,
          @ObjectModel: { virtualElement: true,
                      virtualElementCalculatedBy: 'ABAP:ZCLSD_URL_CONTRACT' }
  virtual URL_FATURA  : eso_longtext,
          @ObjectModel: { virtualElement: true,
                      virtualElementCalculatedBy: 'ABAP:ZCLSD_URL_CONTRACT' }
  virtual URL_NFESAID : eso_longtext,

          /* Associations */
          _Distrato,
          _LocEquip,
          _AnaliseCRCP,
          _DetalheJob,
          _PopCentro
          //      _AnaliseCRCP : redirected to composition child ZC_SD_CR_CP,
          //      _DetalheJob  : redirected to composition child ZC_SD_DET_JOBS
          //      _Distrato    : redirected to composition child ZC_SD_INF_DISTRATO,
          //      _LocEquip    : redirected to composition child ZC_SD_LOC_EQUIP
}
