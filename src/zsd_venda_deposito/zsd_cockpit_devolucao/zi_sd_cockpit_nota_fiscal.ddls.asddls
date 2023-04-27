@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit Devolução Aba Nota fiscal'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COCKPIT_NOTA_FISCAL
  as select from ztsd_devolucao as _Devolucao
  association        to parent ZI_SD_COCKPIT_DEVOLUCAO as _Cockpit     on  $projection.Guid = _Cockpit.Guid
  //  association        to parent ZI_SD_COCKPIT_DEVOLUCAO as _Cockpit on  $projection.LocalNegocio  = _Cockpit.LocalNegocio
  //                                                                   and $projection.TipoDevolucao = _Cockpit.TipoDevolucao
  //                                                                   and $projection.Regiao        = _Cockpit.Regiao
  //                                                                   and $projection.Ano           = _Cockpit.Ano
  //                                                                   and $projection.Mes           = _Cockpit.Mes
  //                                                                   and $projection.Cnpj          = _Cockpit.Cnpj
  //                                                                   and $projection.Modelo        = _Cockpit.Modelo
  //                                                                   and $projection.Serie         = _Cockpit.Serie
  //                                                                   and $projection.Nfe           = _Cockpit.Nfe
  //                                                                   and $projection.DigitoVerific = _Cockpit.DigitoVerific
  association [0..1] to I_SDDocumentReason             as _Reason      on  $projection.Motivo = _Reason.SDDocumentReason
  association [1..1] to t042zt                         as _FormPagText on  $projection.FormPagamento = _FormPagText.zlsch
                                                                       and 'BR'                      = _FormPagText.land1
                                                                       and _FormPagText.spras        = $session.system_language
  association to I_SalesDocument                      as _Ordem        on _Ordem.SalesDocument       = $projection.OrdemDevolucao                                                                     
{

  key  _Devolucao.guid                  as Guid,
       _Devolucao.local_negocio         as LocalNegocio,
       _Devolucao.tipo_devolucao        as TipoDevolucao,
       _Devolucao.regiao                as Regiao,
       _Devolucao.ano                   as Ano,
       _Devolucao.mes                   as Mes,
       _Devolucao.cnpj                  as Cnpj,
       _Devolucao.modelo                as Modelo,
       _Devolucao.serie                 as Serie,
       _Devolucao.numero_nfe            as Nfe,
       _Devolucao.digito_verific        as DigitoVerific,
       _Cockpit.CNPJText                as CNPJText,
       _Devolucao.cliente               as Cliente,
       _Devolucao.dt_lancamento         as DtLancamento,
       _Devolucao.dt_logistica          as DtRecebimento,
       _Devolucao.ord_devolucao         as OrdemDevolucao,
       _Devolucao.centro                as Centro,
       _Ordem.CustomerPurchaseOrderDate as DtRegistro,
       //       _Devolucao.dt_criacao            as DtRegistro,-
       _Ordem.CreationTime              as HrRegistro,
       //       _Devolucao.hr_criacao            as HrRegistro,
       _Cockpit.Remessa                 as Remessa,
       _Cockpit.EntradaMercadoria       as EntradaMercadoria,
       _Cockpit.Fatura                  as Fatura,
       _Cockpit.OrdemComplementar       as OrdemComplementar,
       _Cockpit.NfeComp                 as NfeComp,
       _Cockpit.BloqueioFaturamento     as BloqueioFaturamento,
       @Semantics.amount.currencyCode: 'MoedaSD'
       _Cockpit.NfTotal                 as NfTotal,
       _Cockpit.MoedaSD                 as MoedaSD,
       _Cockpit.BloqueioRemessa         as BloqueioRemessa,
       _Cockpit.Replicacao              as Replicacao,
       _Cockpit.Transferencia           as Transferencia,
       _Cockpit.EMSimbolica             as EMSimbolica,
       _Cockpit.DevReplicada            as DevReplicada,
       _Devolucao.chaveacesso           as ChaveAcesso,
       _Devolucao.dt_administrativo     as DtAdministrativo,
       @ObjectModel.text.element: ['SDDocumentReasonText']
       _Devolucao.motivo                as Motivo,
       _Devolucao.form_pagamento        as FormPagamento,
       cast( ' '  as abap.char( 1 ) )   as confirmaDadosBancarios,
       _Devolucao.flag                  as FlagDadosBancarios,
       _Devolucao.banco                 as Banco,
       _Devolucao.denomi_banco          as DenomiBanco,
       _Devolucao.agencia               as Agencia,
       _Devolucao.conta                 as Conta,
       _Ordem.PurchaseOrderByCustomer   as ProtOcorrencia,
       //       _Devolucao.prot_ocorrencia       as ProtOcorrencia,
       @Semantics.user.createdBy: true
       _Devolucao.created_by            as CreatedBy,
       @Semantics.systemDateTime.createdAt: true
       _Devolucao.created_at            as CreatedAt,
       @Semantics.user.lastChangedBy: true
       _Devolucao.last_changed_by       as LastChangedBy,
       @Semantics.systemDateTime.lastChangedAt: true
       _Devolucao.last_changed_at       as LastChangedAt,
       @Semantics.systemDateTime.localInstanceLastChangedAt: true
       _Devolucao.local_last_changed_at as LocalLastChangedAt,
       _Reason._Text.SDDocumentReasonText,
       _FormPagText.text2               as FormPagText,
       /* associations */
       _Cockpit

}
