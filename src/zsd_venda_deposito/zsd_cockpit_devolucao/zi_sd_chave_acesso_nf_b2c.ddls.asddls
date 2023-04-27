@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Monta Chave de Acesso das Nfs 3C'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CHAVE_ACESSO_NF_B2C
  as select from I_BR_NFDocument as _NfDoc
    inner join   I_BR_NFItem     as _NfItem   on _NfItem.BR_NotaFiscal = _NfDoc.BR_NotaFiscal
    inner join   I_BR_NFeActive  as _NfActive on  _NfActive.BR_NotaFiscal        = _NfDoc.BR_NotaFiscal
                                              and _NfActive.BR_NFeDocumentStatus = '1'
                                              and _NfActive.BR_NFIsCanceled      = ' '
{
  key _NfDoc.BR_NotaFiscal,
      _NfActive.BR_NFeNumber                                                                       as Nfe3,
      _NfActive.BR_NFeSeries                                                                       as Serie3,
      min( _NfItem.BR_NotaFiscalItem )                                                             as Item3,
      _NfItem.Plant                                                                                as Centro3,
      _NfActive.BR_NFeAccessKeyCNPJOrCPF                                                           as Cnpj3,
      _NfDoc.SalesDocumentCurrency                                                                 as Moeda3,
      @Semantics.amount.currencyCode: 'Moeda3'
      _NfDoc.BR_NFTotalAmount                                                                      as ValorTotal3,
      max(_NfDoc.BR_NFPostingDate)                                                                 as DataEmissao3,
      _NfDoc.BR_NFPartner                                                                          as Cliente3,
      _NfDoc.BR_NFPartnerName1                                                                     as NomeCliente3,
      cast ( '3' as ze_tipo_devolucao )                                                            as TpDevolucao3,
      //Chave de Acesso
      concat( _NfActive.Region,
      concat( _NfActive.BR_NFeIssueYear,
      concat( _NfActive.BR_NFeIssueMonth,
      concat( _NfActive.BR_NFeAccessKeyCNPJOrCPF,
      concat( _NfActive.BR_NFeModel,
      concat( _NfActive.BR_NFeSeries,
      concat( _NfActive.BR_NFeNumber,
      concat( _NfActive.IssuingType,
      concat( substring(_NfActive.BR_NFeRandomNumber, 2, 8 ), _NfActive.BR_NFeCheckDigit) )))))))) as ChaveAcesso3

 
}
group by
  _NfDoc.BR_NotaFiscal,
  _NfActive.BR_NFeNumber,
  _NfActive.BR_NFeSeries,
  _NfItem.Plant,
  _NfActive.BR_NFeAccessKeyCNPJOrCPF,
  _NfDoc.SalesDocumentCurrency,
  _NfDoc.BR_NFTotalAmount,
  _NfDoc.BR_NFPartner,
  _NfDoc.BR_NFPartnerName1,
  _NfActive.Region,
  _NfActive.BR_NFeIssueYear,
  _NfActive.BR_NFeIssueMonth,
  _NfActive.BR_NFeModel,
  _NfActive.IssuingType,
  _NfActive.BR_NFeRandomNumber,
  _NfActive.BR_NFeCheckDigit
