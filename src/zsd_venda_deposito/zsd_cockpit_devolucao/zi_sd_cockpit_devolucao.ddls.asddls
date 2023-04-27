@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit Devolução'
define root view entity ZI_SD_COCKPIT_DEVOLUCAO
  as select from    ztsd_devolucao                as _Devolucao
    left outer join ZI_SD_COCKPIT_DEVOLUCAO_REM   as _Remessa     on _Remessa.DocumentoVendas = _Devolucao.ord_devolucao
    left outer join ZI_SD_NFE_3C_STATUS_CANCEL    as _Nfe3C       on _Nfe3C.DocOrigem = _Remessa.Fatura
    left outer join ZI_SD_COCKPIT_DEVOLUCAO_NFNUM as _Nfe3CStatus on _Nfe3CStatus.DocOrigem = _Remessa.Fatura
  composition [0..*] of ZI_SD_COCKPIT_DEVOLUCAO_ANEXO as _Arquivo
  composition [0..*] of ZI_SD_COCKPIT_NOTA_FISCAL     as _NotaFiscal
  composition [0..*] of ZI_SD_COCKPIT_DEVOLUCAO_INFOS as _Informacoes
  composition [0..*] of ZI_SD_COCKPIT_DEVOLUCAO_TRANS as _Transporte
  association        to I_SalesDocument                      as _Ordem       on  _Ordem.SalesDocument                 = $projection.OrdemDevSelect
                                                                             and _Ordem.OverallSDDocumentRejectionSts <> 'C'
  association        to ZI_SD_COCKPIT_DEVOLUCAO_DF           as _Deposito    on  _Deposito.OrdemDevolucao = $projection.OrdemDevSelect
  association        to ZI_SD_TRANSF_SIMB                    as _Transf      on  _Transf.Nfe = $projection.Nfe
  association        to ZI_SD_ENTRAD_MERC                    as _EntMerc     on  _EntMerc.Nfe = $projection.Nfe
  association        to ZI_SD_DEVOLUCAO_REPLIC               as _Replica     on  _Replica.Nfe = $projection.Nfe
  association        to dd07t                                as _TextoStatus on  _TextoStatus.domvalue_l = $projection.Situacao
                                                                             and _TextoStatus.domname    = 'ZD_SITUACAO_DEV'
                                                                             and _TextoStatus.as4local   = 'A'
                                                                             and _TextoStatus.ddlanguage = $session.system_language
  association        to ZI_SD_NFE_IN_STATUS_CANCEL           as _NfeCliente  on  _NfeCliente.nfeid = $projection.ChaveAcesso
  association [1..1] to I_SDDocumentReason            as _Reason             on  $projection.Motivo = _Reason.SDDocumentReason
  association [1..1] to t042zt                        as _FormPagText        on  $projection.FormaPagamento = _FormPagText.zlsch
                                                                             and 'BR'                       = _FormPagText.land1
                                                                             and _FormPagText.spras         = $session.system_language
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
       _Devolucao.nro_aleatorio         as NroAleatorio,
       _Devolucao.digito_verific        as DigitoVerific,
       case when _Devolucao.cnpj is initial then ''
            when length(_Devolucao.cnpj) = 14 then
            concat( substring(_Devolucao.cnpj, 1, 2),
                concat( '.',
                concat( substring(_Devolucao.cnpj, 3, 3),
                concat( '.',
                concat( substring(_Devolucao.cnpj, 6, 3),
                concat( '/',
                concat( substring(_Devolucao.cnpj, 9, 4),
                concat( '-',  substring(_Devolucao.cnpj, 13, 2) ) ) ) ) ) ) ) )
           else concat( substring(_Devolucao.cnpj, 1, 3),
                concat( '.',
                concat( substring(_Devolucao.cnpj,4, 3),
                concat( '.',
                concat( substring(_Devolucao.cnpj, 7, 3),
                concat( '-',  substring(_Devolucao.cnpj, 10, 2) ) ) ) ) ) )
       end                              as CNPJText,

       case  _Devolucao.tipo_devolucao
       when '1' then 'Nf-e emitida pelo Cliente '
       when '2' then 'Retorno da Empresa'
       when '3' then 'Devolução E-Commerce B2C'
       when '4' then 'Devolução com complemento de imposto RS'
       else ' '
       end                              as TipoDevText,

       _Devolucao.cliente               as Cliente,
       _Devolucao.dt_lancamento         as DtLancamento,
       @EndUserText.label: 'Data Logística'
       _Devolucao.dt_logistica          as DtRecebimento,

       _Devolucao.ord_devolucao         as OrdemDevSelect,

       case
       when _Ordem.SalesDocument <> ''
       then _Devolucao.ord_devolucao
       else cast ( '' as vbeln_va )
       end                              as OrdemDevolucao,

       _Devolucao.centro                as Centro,

       case
       when _Devolucao.prot_ocorrencia is not initial
       then _Ordem.CreationDate
       else cast( '00000000' as abap.dats(8) )
       end                              as DtRegistro,
       //       _Devolucao.dt_criacao            as DtRegistro,-
       case
       when _Devolucao.prot_ocorrencia is not initial
       then _Ordem.CreationTime
       else cast( '000000' as abap.tims(6) )
       end                              as HrRegistro,
       //       _Devolucao.hr_criacao            as HrRegistro,
       _Remessa.Remessa                 as Remessa,

       case _Remessa.StatusMovMercadorias
         when 'C' then 'Sim'
         else 'Não '
        end                             as EntradaMercadoria,

       //       _Devolucao.fatura                as FaturaDev,

       case
       when _Nfe3CStatus.Cancelado = ' '
       then _Remessa.Fatura
       else ''
       end                              as Fatura,

       _Remessa.DocNf                   as DocNum,

       case
       when _Nfe3CStatus.Cancelado = ' ' and _Nfe3CStatus.DocNfStatus  = ' '
       then cast( '1' as ze_status_nf_dev ) //'1ª tela'
       when _Nfe3CStatus.Cancelado = ' ' and _Nfe3CStatus.DocNfStatus  = '1'
       then cast( '2' as ze_status_nf_dev ) //'Autorizada'
       when _Nfe3CStatus.Cancelado = ' ' and _Nfe3CStatus.DocNfStatus  = '2'
       then cast( '3' as ze_status_nf_dev ) //'Recusado'
       when _Nfe3CStatus.Cancelado = ' ' and _Nfe3CStatus.DocNfStatus  = '3'
       then cast( '4' as ze_status_nf_dev ) //'Rejeitado'
       else cast( ' ' as ze_status_nf_dev )
       end                              as StatusNFe,


       case
       when _Nfe3CStatus.Cancelado = ' ' and _Nfe3CStatus.DocNfStatus  = ' '
       then '1ª tela'
       when _Nfe3CStatus.Cancelado = ' ' and _Nfe3CStatus.DocNfStatus  = '1'
       then 'Autorizada'
       when _Nfe3CStatus.Cancelado = ' ' and _Nfe3CStatus.DocNfStatus  = '2'
       then 'Recusado'
       when _Nfe3CStatus.Cancelado = ' ' and _Nfe3CStatus.DocNfStatus  = '3'
       then 'Rejeitado'
       else ''
       end                              as StatusNFeTexto,

       case
       when _Nfe3CStatus.Cancelado = ' ' and _Nfe3CStatus.DocNfStatus  = ' '
       then 2 //Amarelo
       when _Nfe3CStatus.Cancelado = ' ' and _Nfe3CStatus.DocNfStatus  = '1'
       then 3 //Verde
       when _Nfe3CStatus.Cancelado = ' ' and _Nfe3CStatus.DocNfStatus  = '2'
       then 1 //Vermelho
       when _Nfe3CStatus.Cancelado = ' ' and _Nfe3CStatus.DocNfStatus  = '3'
       then 1 //Vermelho
       else 0 //Cinza
       end                              as CorStatusNFe,

       _Remessa.OrdemComplementar       as OrdemComplementar,
       _Remessa.NfeComp                 as NfeComp,
       _Remessa.BloqueioFaturamento     as BloqueioFaturamento,

       @Semantics.amount.currencyCode: 'MoedaSD'
       _Devolucao.valor_totalnfe        as NfTotal,
       _Devolucao.moedasd               as MoedaSD,

       //       _Ordem.DeliveryBlockReason       as BloqueioRemessa,
       _Remessa.BloqueioRemessa         as BloqueioRemessa,

       case
         when _Deposito.Centro is not null then 'X'
         else ' '
        end                             as Replicacao,
       _Transf.NumDocMat                as Transferencia,
       _EntMerc.EntradMerc              as EMSimbolica,
       _Replica.Devolucao               as DevReplicada,
       _Devolucao.transportadora        as Transportadora,
       _Devolucao.motorista             as Motorista,
       _Devolucao.tipo_expedicao        as TipoExpedicao,
       _Devolucao.placa                 as Placa,

       case
       when _Nfe3C.code <> ''
       then cast( '3' as ze_situacao_dev )
       when _NfeCliente.statcod <> ''
       then cast( '3' as ze_situacao_dev )
       when _Nfe3CStatus.Cancelado = ' '
       then cast( '2' as ze_situacao_dev )
       when _Devolucao.ord_devolucao is not initial and _Ordem.SalesDocument <> ' ' and ( _Devolucao.fatura is initial or _Nfe3CStatus.Cancelado = 'X' )
       then cast( '1' as ze_situacao_dev )
       when _Devolucao.numero_nfe is not initial and _Devolucao.ord_devolucao is initial
       then cast( '0' as ze_situacao_dev )
       else cast( '0' as ze_situacao_dev )
       end                              as CodSituacao,

       _Devolucao.situacao              as Situacao,

       case _Devolucao.situacao
       when '0'//Em Pré Registro
       then  0 //Cinza
       when '1'//Em Ordem
       then  3 //Verde
       when '2'//Lançada
       then  3 //Verde
       when '3'//Cancelada
       then  1 //Vermelho
       when '4'//Substituída
       then  2 //Amarelo
       when '5'//Lançada por Fluig
       then  2 //Amarelo
       when '6'//Pendente
       then  2 //Amarelo
       else  0 //Cinza
       end                              as CorSituacao,

       _TextoStatus.ddtext              as StatusText,

       _Devolucao.chaveacesso           as ChaveAcesso,
       _Devolucao.dt_administrativo     as DtAdministrativo,
       _Devolucao.motivo                as Motivo,
       _Devolucao.form_pagamento        as FormaPagamento,
       _FormPagText.text2               as FormPagText,
       _Devolucao.banco                 as Banco,
       _Devolucao.denomi_banco          as DenomiBanco,
       _Devolucao.agencia               as Agencia,
       _Devolucao.conta                 as Conta,
       //       _Ordem.PurchaseOrderByCustomer   as ProtOcorrencia,
       _Devolucao.prot_ocorrencia       as ProtOcorrencia,
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
       cast( 'X' as flag )              as Enable,
       _Reason._Text.SDDocumentReasonText,
       /* associations */
       _Arquivo,
       _NotaFiscal,
       _Informacoes,
       _Transporte

}
