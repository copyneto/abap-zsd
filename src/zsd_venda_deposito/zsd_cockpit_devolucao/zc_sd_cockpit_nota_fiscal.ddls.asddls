@EndUserText.label: 'Cockpit Devolução Aba Nota fiscal'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_SD_COCKPIT_NOTA_FISCAL
  as projection on ZI_SD_COCKPIT_NOTA_FISCAL
{
       @UI.hidden: true
  key  Guid,
       LocalNegocio,
       TipoDevolucao,
       Regiao,
       Ano,
       Mes,
       Cnpj,
       Modelo,
       Serie,
       @EndUserText.label: 'Nº Nf-e'
       Nfe,
       @EndUserText.label: 'Dígito verificador'
       DigitoVerific,
       @UI.hidden: true
       CNPJText,
       Cliente,
       @EndUserText.label: 'Data Lançamento'
       DtLancamento,
       @EndUserText.label: 'Data Logística'
       DtRecebimento,
       @EndUserText.label: 'Ordem Devolução'
       OrdemDevolucao,
       Centro,
       @EndUserText.label: 'Data da ocorrência'
       DtRegistro,
       @EndUserText.label: 'Hora da ocorrência'
       HrRegistro,
       Remessa,
       @EndUserText.label: 'EM'
       EntradaMercadoria,
       @EndUserText.label: 'Fatura'
       Fatura,
       @EndUserText.label: 'Ordem Complementar'
       OrdemComplementar,
       @EndUserText.label: 'Nfe Complementar'
       NfeComp,
       @EndUserText.label: 'Bloqueio Faturamento'
       BloqueioFaturamento,
       @Semantics.amount.currencyCode: 'MoedaSD'
       @EndUserText.label: 'Total NF-e'
       NfTotal,
       MoedaSD,
       @EndUserText.label: 'Bloqueio Remessa'
       BloqueioRemessa,
       @EndUserText.label: 'Relevância para replicação'
       Replicacao,
       @UI.hidden: true
       Transferencia,
       @EndUserText.label: 'Entrada Mercadoria'
       EMSimbolica,
       @EndUserText.label: 'Devolução Replicada'
       DevReplicada,
       @EndUserText.label: 'Chave de Acesso'
       ChaveAcesso,
       DtAdministrativo,
       @Consumption.valueHelpDefinition: [{
       entity: { name: 'I_SDDocumentReason',
       element: 'SDDocumentReason' }
       }]
       Motivo,
       @Consumption.valueHelpDefinition: [{
       entity: { name: 'ZI_SD_VH_MEIO_PAGAMENTO',
       element: 'FormaPagtoId' },
       additionalBinding: [ {element: 'Nfe' , localElement: 'Nfe', usage: #FILTER },
                            {element: 'ChaveAcesso' , localElement: 'ChaveAcesso', usage: #FILTER },
                            {element: 'Banco', localElement: 'Banco', usage: #RESULT },
                            {element: 'DenomiBanco', localElement: 'DenomiBanco', usage: #RESULT },
                            {element: 'Agencia', localElement: 'Agencia', usage: #RESULT },
                            {element: 'Conta', localElement: 'Conta', usage: #RESULT },
                            {element: 'FlagDadosBancarios', localElement: 'FlagDadosBancarios', usage: #RESULT }]

       }]
       @ObjectModel.text.element:['FormPagText']
       @EndUserText.label: 'Meio de pagamento'
       FormPagamento,
       @UI.hidden: true
       FormPagText,
       @UI.hidden: true
       confirmaDadosBancarios,
       FlagDadosBancarios,
       Banco,
       @Consumption.valueHelpDefinition: [{entity: {name: 'I_Bank', element: 'BankName' }}]
       DenomiBanco,
       @EndUserText.label: 'Agência bancária'
       Agencia,
       Conta,
       ProtOcorrencia,
       @Semantics.user.createdBy: true
       CreatedBy,
       @Semantics.systemDateTime.createdAt: true
       CreatedAt,
       @Semantics.user.lastChangedBy: true
       LastChangedBy,
       @Semantics.systemDateTime.lastChangedAt: true
       LastChangedAt,
       @Semantics.systemDateTime.localInstanceLastChangedAt: true
       LocalLastChangedAt,
       @UI.hidden: true
       SDDocumentReasonText,
       /* associations */
       _Cockpit : redirected to parent ZC_SD_COCKPIT_DEVOLUCAO
}
