@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit Devolução'
@Metadata.allowExtensions: true
@UI.presentationVariant: [{ sortOrder: [{ by: 'TipoDevolucao', direction: #ASC }] }]
define root view entity ZC_SD_COCKPIT_DEVOLUCAO
  as projection on ZI_SD_COCKPIT_DEVOLUCAO as Cockpit
{
          @UI.hidden: true
  key     Guid,
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_BRANCH', element: 'BusinessPlace' }}]
          LocalNegocio,
          //       @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_SD_VH_TIPO_DEV', element : 'TipoDev' }}]
          @Consumption.valueHelpDefinition: [{
           entity: { name: 'ZI_SD_VH_ENABLE_NFE',element: 'TipoDev' },
          additionalBinding: [{ element: 'Enable', localElement: 'Enable', usage: #RESULT }]}]
          @ObjectModel.text.element:['TipoDevText']
          TipoDevolucao,
          Regiao,
          Ano,
          Mes,
          @EndUserText.label: 'CNPJ/CPF'
          //      @ObjectModel.text.element: ['CNPJText']
          Cnpj,
          Modelo,
          Serie,
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_NOTA_DEVOLUCAO', element: 'Nfe' }}]
          Nfe,
          @EndUserText.label: 'Dígito verificador'
          DigitoVerific,
          //      @EndUserText.label: 'CNPJ/CPF Text'
          //      CNPJText,
          @UI.hidden: true
          TipoDevText,
          //      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_CUSTOMER', element: 'Customer' }}]
          @Consumption.valueHelpDefinition: [ { entity:  { name:    'I_Customer_VH', element: 'Customer' } }]
          Cliente,
          @Consumption.filter.mandatory: true
          @EndUserText.label: 'Data Lançamento'
          DtLancamento,
          @EndUserText.label: 'Data Logística'
          DtRecebimento  as DtLogistica,
          @EndUserText.label: 'Ordem Devolução'
          OrdemDevolucao as SalesOrder,
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_WERKS', element: 'WerksCode' }}]
          @EndUserText.label: 'Centro'
          Centro,
          @EndUserText.label: 'Data da ocorrência'
          DtRegistro,
          @EndUserText.label: 'Hora da ocorrência'
          HrRegistro,
          @EndUserText.label: 'Remessa'
          Remessa        as OutboundDelivery,
          @EndUserText.label: 'EM'
          EntradaMercadoria,
          @EndUserText.label: 'Fatura'
          Fatura         as BillingDocument,
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_DOCNUM', element: 'BR_NotaFiscal' }}]
          @EndUserText.label: 'DocNum'
          DocNum,
          @EndUserText.label: 'Status NF-e'
          @ObjectModel.text.element:['StatusNFeTexto']
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STATUS_NF_DEV', element: 'StatusNf' }}]
          StatusNFe,
          @UI.hidden: true
          StatusNFeTexto,
          @UI.hidden: true
          CorStatusNFe,
          @EndUserText.label: 'Ordem Complementar'
          OrdemComplementar,
          @EndUserText.label: 'Nf-e Complementar'
          NfeComp,
          @Consumption.hidden: true
          @UI.hidden: true
          @EndUserText.label: 'Bloqueio Faturamento'
          BloqueioFaturamento,
          @EndUserText.label: 'Total NF-e'
          NfTotal,
          MoedaSD,
          @EndUserText.label: 'Bloqueio Remessa'
          BloqueioRemessa,
          @EndUserText.label: 'Relevância para replicação'
          Replicacao,
          @EndUserText.label: 'Transferência'
          Transferencia,
          @EndUserText.label: 'Entrada Mercadoria'
          EMSimbolica,
          @EndUserText.label: 'Devolução Replicada'
          DevReplicada,

          //      @Consumption.valueHelpDefinition: [{
          //      //       entity: { name: 'ZI_SD_VH_CHAVE_ACESSO_DEV',
          //      entity: { name: 'ZI_SD_CHAVE_ACESSO_NF_3C',
          //      element: 'ChaveAcesso2' },
          //      //       additionalBinding: [{element: 'Centro', localElement: 'Centro', usage: #FILTER_AND_RESULT },
          //      //                           {element: 'Cnpj',   localElement: 'Cnpj',   usage: #FILTER_AND_RESULT },
          //      //                           {element: 'Nfe',    localElement: 'Nfe',    usage: #FILTER_AND_RESULT  },
          //      //                           {element: 'Serie',  localElement: 'Serie',  usage: #FILTER_AND_RESULT  }]}]
          //      additionalBinding: [{element: 'Nfe2',    localElement: 'Nfe',    usage: #FILTER_AND_RESULT  },
          //                          //{element: 'Cnpj2',   localElement: 'Cnpj',    usage: #FILTER_AND_RESULT  },
          //                          {element: 'Serie2',   localElement: 'Serie',    usage: #FILTER_AND_RESULT  },
          //                          {element: 'Centro2', localElement: 'Centro', usage: #FILTER_AND_RESULT }]}]


          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_CHAVE_ACESSO_DEVOL', element: 'ChaveAcesso' },
                         additionalBinding: [{element: 'Nfe',    localElement: 'Nfe',    usage: #FILTER_AND_RESULT  },
                                             {element: 'TpDevolucao', localElement: 'TipoDevolucao', usage: #FILTER  },
          //                                         {element: 'Cnpj',   localElement: 'Cnpj',    usage: #FILTER_AND_RESULT  },
                                             {element: 'Serie',   localElement: 'Serie',    usage: #FILTER_AND_RESULT  },
                                             {element: 'Centro', localElement: 'Centro', usage: #FILTER_AND_RESULT }]}]
          @EndUserText.label: 'Chave de Acesso'
          ChaveAcesso,
          @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_SITUACAO_DEV', element: 'Situacao' }}]
          @ObjectModel.text.element: [ 'StatusText' ]
          Situacao,
          @UI.hidden: true
          CorSituacao,
          @UI.hidden: true
          StatusText,
          Enable,
          @EndUserText.label: 'Data Administrativo'
          DtAdministrativo,
          @Consumption.valueHelpDefinition: [{
          entity: { name: 'I_SDDocumentReason',
          element: 'SDDocumentReason' }
          }]
          @ObjectModel.text.element: ['SDDocumentReasonText']
          Motivo,
          @Consumption.valueHelpDefinition: [{
          entity: { name: 'ZI_CA_VH_FORM_PAGTO',
                    element: 'FormaPagtoId' }
          }]
          @EndUserText.label: 'Meio de pagamento'
          @ObjectModel.text.element:['FormPagText']
          FormaPagamento,
          @UI.hidden: true
          FormPagText,
          Banco,
          @Consumption.valueHelpDefinition: [{entity: {name: 'I_Bank', element: 'BankName' }}]
          @EndUserText.label: 'Instituição financeira '
          DenomiBanco,
          @EndUserText.label: 'Agência bancária'
          Agencia,
          Conta,
          @EndUserText.label: 'Prot.Ocorrência'
          ProtOcorrencia,
          CreatedBy,
          CreatedAt,
          LastChangedBy,
          LastChangedAt,
          LocalLastChangedAt,
          @UI.hidden: true
          SDDocumentReasonText,
          @UI.hidden: true
          @ObjectModel: { virtualElement: true,
                    virtualElementCalculatedBy: 'ABAP:ZCLSD_COCKPIT_DEVOLUCAO_URL' }
  virtual URL_va03  : eso_longtext,
          @UI.hidden: true
          @ObjectModel: { virtualElement: true,
                        virtualElementCalculatedBy: 'ABAP:ZCLSD_COCKPIT_DEVOLUCAO_URL' }
  virtual URL_vl03n : eso_longtext,
          @UI.hidden: true
          @ObjectModel: { virtualElement: true,
                        virtualElementCalculatedBy: 'ABAP:ZCLSD_COCKPIT_DEVOLUCAO_URL' }
  virtual URL_vf03  : eso_longtext,
          @UI.hidden: true
          @ObjectModel: { virtualElement: true,
                    virtualElementCalculatedBy: 'ABAP:ZCLSD_COCKPIT_DEVOLUCAO_URL' }
  virtual URL_j1b3n : eso_longtext,

          /* Associations */
          _Arquivo     : redirected to composition child ZC_SD_COCKPIT_DEVOLUCAO_ANEXO,
          _NotaFiscal  : redirected to composition child ZC_SD_COCKPIT_NOTA_FISCAL,
          _Informacoes : redirected to composition child ZC_SD_COCKPIT_DEVOLUCAO_INFOS,
          _Transporte  : redirected to composition child ZC_SD_COCKPIT_DEVOLUCAO_TRANS

}
