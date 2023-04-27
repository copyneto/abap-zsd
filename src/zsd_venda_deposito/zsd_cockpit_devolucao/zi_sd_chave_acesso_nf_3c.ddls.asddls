@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Monta Chave de Acesso das Nfs 3C'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CHAVE_ACESSO_NF_3C
  as select from I_BR_NFDocument as _NfDoc
    inner join   I_BR_NFItem     as _NfItem   on _NfItem.BR_NotaFiscal = _NfDoc.BR_NotaFiscal
    inner join   I_BR_NFeActive  as _NfActive on  _NfActive.BR_NotaFiscal        = _NfDoc.BR_NotaFiscal
                                              and _NfActive.BR_NFeDocumentStatus = '1'
                                              and _NfActive.BR_NFIsCanceled      = ' '
{
  key     'SH'                                                                                         as SearchHelp,
          //  key   _NfDoc.BR_NotaFiscal,
  key     _NfActive.BR_NFeNumber                                                                       as Nfe2,
          _NfActive.BR_NFeSeries                                                                       as Serie2,
          min( _NfItem.BR_NotaFiscalItem )                                                             as Item2,
          _NfItem.Plant                                                                                as Centro2,
          cast( _NfActive.BR_NFeAccessKeyCNPJOrCPF as abap.char( 16 ))                                 as Cnpj2,
          _NfDoc.SalesDocumentCurrency                                                                 as Moeda2,
          @Semantics.amount.currencyCode: 'Moeda2'
          _NfDoc.BR_NFTotalAmount                                                                      as ValorTotal2,
          max(_NfDoc.BR_NFPostingDate)                                                                 as DataEmissao2,
          _NfDoc.BR_NFPartner                                                                          as Cliente2,
          _NfDoc.BR_NFPartnerName1                                                                     as NomeCliente2,
          cast ( '2' as ze_tipo_devolucao )                                                            as TpDevolucao2,

          _NfDoc.BusinessPlaceStateTaxNumber                                                           as CodFiscal,
          _NfDoc.BusPlaceMunicipalTaxNumber                                                            as CodMunicipal,
          cast( _NfDoc.BR_BusinessPlaceCNAE   as abap.char(18))                                        as Cnae,


          //Chave de Acesso
          concat( _NfActive.Region,
          concat( _NfActive.BR_NFeIssueYear,
          concat( _NfActive.BR_NFeIssueMonth,
          concat( _NfActive.BR_NFeAccessKeyCNPJOrCPF,
          concat( _NfActive.BR_NFeModel,
          concat( _NfActive.BR_NFeSeries,
          concat( _NfActive.BR_NFeNumber,
          concat( _NfActive.IssuingType,
          concat( substring(_NfActive.BR_NFeRandomNumber, 2, 8 ), _NfActive.BR_NFeCheckDigit) )))))))) as ChaveAcesso2,
          _NfDoc.BR_NotaFiscal                                                                         as Docnum

}
group by
  _NfActive.BR_NFeNumber,
  _NfActive.BR_NFeSeries,
  _NfItem.Plant,
  _NfActive.BR_NFeAccessKeyCNPJOrCPF,
  _NfDoc.SalesDocumentCurrency,
  _NfDoc.BR_NFTotalAmount,
  _NfDoc.BR_NFPartner,
  _NfDoc.BR_NFPartnerName1,
  _NfDoc.BusinessPlaceStateTaxNumber,
  _NfDoc.BusPlaceMunicipalTaxNumber,
  _NfDoc.BR_BusinessPlaceCNAE,
  _NfActive.Region,
  _NfActive.BR_NFeIssueYear,
  _NfActive.BR_NFeIssueMonth,
  _NfActive.BR_NFeModel,
  _NfActive.IssuingType,
  _NfActive.BR_NFeRandomNumber,
  _NfActive.BR_NFeCheckDigit,
  _NfDoc.BR_NotaFiscal
