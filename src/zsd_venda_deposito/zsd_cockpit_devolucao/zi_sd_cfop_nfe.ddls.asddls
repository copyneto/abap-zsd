@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS buscar Cfop no parametro e Nfe'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CFOP_NFE
  as select from I_BR_NFDocument as _NfDoc
    inner join   I_BR_NFItem     as _NfItem     on _NfItem.BR_NotaFiscal = _NfDoc.BR_NotaFiscal
    inner join   /xnfe/innfehd   as _NfeInbound on _NfDoc.BR_NFeNumber = LTRIM(
      substring(
        _NfeInbound.nfeid, 26, 9
      ), '0'
    )
  //                                               and _NfDoc.BR_NFPartnerCNPJ = _NfeInbound.cnpj_dest

  association to ZI_SD_NFE_DEVOLUCAO_CANCEL as _NotaCancelada on _NotaCancelada.ChaveAcesso = _NfeInbound.nfeid

{
  key  cast( _NfeInbound.cnpj_emit  as abap.char(16) ) as CnpjEmissor,
  key  _NfeInbound.dsaient                             as DtSaidaNfe,
  key  cast ( '1' as ze_tipo_devolucao )               as TpDevolucao,
       _NfeInbound.nfeid                               as ChaveAcesso,
       @Semantics.amount.currencyCode: 'CodMoeda'
       _NfeInbound.s1_vnf                              as ValorTotal,
       _NfeInbound.waers                               as CodMoeda,
       _NfeInbound.natop                               as DescriOperacao,
       _NfeInbound.type                                as TipoNfe,
       _NfeInbound.finnfe                              as NfeNormal,
       _NfeInbound.nnf                                 as Nfe,
       //       _NfDoc.BR_NotaFiscal                            as Docnum,
       max(_NfDoc.BR_NFPostingDate)                    as DataEmissao,
       _NfDoc.BR_NFPartner                             as Cliente,
       _NfDoc.BR_NFPartnerName1                        as NomeCliente,
       _NfeInbound.serie                               as Serie,
       _NfeInbound.cnpj_dest                           as CnpjDest,
       _NfItem.Plant                                   as Centro,
       min( _NfItem.BR_NotaFiscalItem )                as Item,
       _NotaCancelada.ChavePrimaria                    as ChavePrimaria,
       _NfeInbound.guid_header                         as GuiOperacao
}
group by
  _NfeInbound.cnpj_emit,
  _NfeInbound.dsaient,
  _NfeInbound.nfeid,
  _NfeInbound.s1_vnf,
  _NfeInbound.waers,
  _NfeInbound.natop,
  _NfeInbound.type,
  _NfeInbound.finnfe,
  //  _NfDoc.BR_NotaFiscal,
  //  _NfDoc.BR_NFPostingDate,
  _NfDoc.BR_NFPartner,
  _NfDoc.BR_NFPartnerName1,
  _NfeInbound.nnf,
  _NfeInbound.serie,
  _NfeInbound.cnpj_dest,
  _NfItem.Plant,
  _NotaCancelada.ChavePrimaria,
  _NfeInbound.guid_header
