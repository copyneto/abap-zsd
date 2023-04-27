@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit de Devolução - Ordens'
@Metadata.allowExtensions: true
define root view entity ZC_SD_COCKPIT_DEVOLUCAO_EXT
  as projection on ZI_SD_COCKPIT_DEVOLUCAO_EXT
{
                @EndUserText.label: 'Ordem de devolução'
                @Consumption.valueHelpDefinition: [ { entity:  { name: 'ZI_SD_VH_ORDEM_DEV', element: 'Ordem' } }]
  key           Ordem,
                @UI.hidden: true
  key           Item,
  key           Remessa,
                @ObjectModel.text.element:['TextoTipoOrdem']
                @EndUserText.label: 'Tipo de ordem'
                @Consumption.valueHelpDefinition: [ { entity:  { name:    'ZI_SD_VH_ORDERTYPE_DEV', element: 'SalesDocumentType' } }]
                TipoOrdem,
                @UI.hidden: true
                TextoTipoOrdem,
                @Consumption.valueHelpDefinition: [ { entity:  { name:    'I_Customer_VH', element: 'Customer' } }]
                Cliente,
                @EndUserText.label: 'Nome Cliente'
                NomeCliente,
                @EndUserText.label: 'CNPJ/CPF do cliente'
                CnpjCpf,
                @Consumption.valueHelpDefinition: [ { entity:  { name: 'ZI_CA_VH_LIFSK', element: 'DeliveryBlock' } }]
                BloqueioRemessa,
                @EndUserText.label: 'Entrada de mercadoria'
                @Consumption.valueHelpDefinition: [ { entity:  { name: 'ZI_CA_VH_FLAG', element: 'Flag' } }]
                EM,
                @EndUserText.label: 'Fatura'
                Fatura,
                @EndUserText.label: 'Docnum'
                @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_DOCNUM', element: 'BR_NotaFiscal' }}]
                Docnum,
                @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_NFENUM', element: 'nfenum' }}]
                @EndUserText.label: 'Número Nf-e'
                Nfenum,
                @ObjectModel.text.element:['TextoNfStatus']
                @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_STATUSNFE', element: 'DomvalueL' }}]
                @EndUserText.label: 'Status Nfe'
                NfStatus,
                @UI.hidden: true
                TextoNfStatus,
                @UI.hidden: true
                NfStatusColor,
                @EndUserText.label: 'Total Nfe'
                NfTotal,
                @EndUserText.label: 'Moeda'
                MoedaSD,
                @EndUserText.label: 'Motivo da ordem'
                @ObjectModel.text.element: [ 'MotivoOrdemText' ]
                @Consumption.valueHelpDefinition: [{entity: {name: 'I_SDDocumentReason', element: 'SDDocumentReason' }}]
                MotivoOrdem,
                @UI.hidden: true
                MotivoOrdemText,
                @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_SITUACAO_DEV_ORD', element: 'Situacao' }}]
                @ObjectModel.text.element: [ 'StatusText' ]
                @EndUserText.label: 'Situação'
                Situacao,
                @UI.hidden: true
                SituacaoColor,
                @UI.hidden: true
                StatusText,
                @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_WERKS', element: 'WerksCode' }}]
                Centro,
                @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_BRANCH', element: 'BusinessPlace' }}]
                LocalNegocio,
                @EndUserText.label: 'Tipo de pedido'
                @Consumption.valueHelpDefinition: [ { entity:  { name: 'I_CustomerPurchaseOrderType', element: 'CustomerPurchaseOrderType' } }]
                TipoPedido,
                @EndUserText.label: 'Protocolo de ocorrência'
                ProtocoloOcorrencia,
                @EndUserText.label: 'Data ocorrência'
                DataOcorrencia,
                @EndUserText.label: 'Hora ocorrência'
                HoraOcorrencia,
                @EndUserText.label: 'Criado Por'
                CriadoPor,
                @EndUserText.label: 'Meio de pagamento'
                @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_ZLSCH', element: 'FormaPagamento' }}]
                @ObjectModel.text.element:['FormPagText']
                MeioPagamento,
                @UI.hidden: true
                FormPagText,
                @UI.hidden: true
                @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLSD_COCKPIT_DEVOL_EXT_URL' }
  virtual       URL_va03  : eso_longtext,
                @UI.hidden: true
                @ObjectModel: { virtualElement: true,
                              virtualElementCalculatedBy: 'ABAP:ZCLSD_COCKPIT_DEVOL_EXT_URL' }
  virtual       URL_vl03n : eso_longtext,
                @UI.hidden: true
                @ObjectModel: { virtualElement: true,
                              virtualElementCalculatedBy: 'ABAP:ZCLSD_COCKPIT_DEVOL_EXT_URL' }
  virtual       URL_vf03  : eso_longtext,

                @UI.hidden: true
                @ObjectModel: { virtualElement: true,
                              virtualElementCalculatedBy: 'ABAP:ZCLSD_COCKPIT_DEVOL_EXT_URL' }
  virtual       URL_j1b3n : eso_longtext
}
