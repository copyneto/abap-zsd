@AbapCatalog.sqlViewName: 'ZISD_CD_GERDEV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit Devolução Gerar Devolução'
define root view ZI_SD_COCKPIT_DEVOLUCAO_GERDEV
  as select from ztsd_devolucao as _Devolucao
  composition [0..*] of ZI_SD_COCKPIT_DEVOLUCAO_REFVAL as _RefVal
  association [0..*] to dd07t                          as _TextoStatus on  _TextoStatus.domvalue_l = $projection.Situacao
                                                                       and _TextoStatus.domname    = 'ZD_SITUACAO_DEV'
                                                                       and _TextoStatus.as4local   = 'A'
                                                                       and _TextoStatus.ddlanguage = $session.system_language
  association [0..1] to I_SDDocumentReason             as _Reason      on  $projection.Motivo = _Reason.SDDocumentReason
  association        to ZI_SD_COCKPIT_DEVOLUCAO               as _Dev  on  _Dev.Guid = $projection.Guid
  //  association to ZI_SD_GERDEV_INFOS_RECEB              as _InfosReceb on  _InfosReceb.CNPJCliente = _Devolucao.cnpj
  //                                                                      and _InfosReceb.Centro      = _Devolucao.centro
  //  association [1..1] to ZI_SD_GERDEV_INFOS_RECEB              as _InfosReceb on  _InfosReceb.Centro = _Devolucao.centro
  //                                                                      and _InfosReceb.ChaveAcesso = _Devolucao.chaveacesso
{


  key _Devolucao.guid                  as Guid,
      _Devolucao.local_negocio         as LocalNegocio,
      _Devolucao.tipo_devolucao        as TpDevolucao,
      _Devolucao.regiao                as Regiao,
      _Devolucao.ano                   as Ano,
      _Devolucao.mes                   as Mes,
      _Devolucao.cnpj                  as Cnpj,
      _Devolucao.modelo                as Modelo,
      _Devolucao.serie                 as Serie,
      _Devolucao.numero_nfe            as NumNFe,
      _Devolucao.digito_verific        as DigitoVerific,
      _Devolucao.material              as Material,
      _Devolucao.dt_lancamento         as DataLancamento,
      //      _InfosReceb.CodMoeda             as CodMoeda,
      //      @Semantics.amount.currencyCode: 'CodMoeda'
      //      _InfosReceb.ValorTotalNota       as ValorTotalNFe,
      //      _InfosReceb.CodigoEAN            as CodigoEAN,
      _Devolucao.moedasd               as CodMoeda,
      @Semantics.amount.currencyCode: 'CodMoeda'
      _Devolucao.valor_totalnfe        as ValorTotalNFe,
      _Devolucao.cliente               as Cliente,
      _Devolucao.situacao              as Situacao,
      _Devolucao.motivo                as Motivo,
      _Devolucao.transportadora        as Transportadora,
      _Devolucao.motorista             as Motorista,
      _Devolucao.chaveacesso           as ChaveAcesso,
      @Semantics.amount.currencyCode: 'CodMoeda'
      _Devolucao.valor_totalnfe        as ValorUnit,
      _Devolucao.quantidade_nfe        as Quantidade,
      _Devolucao.unmedida_nfe          as UnidMedida,
      _Devolucao.fatura                as Fatura,
      _Devolucao.item                  as Item,
      _Devolucao.un_fatura             as UnMedidaFatura,
      @Semantics.quantity.unitOfMeasure : 'UnMedidaFatura'
      _Devolucao.qtd_fatura            as QuantidadeFatura,
      _Devolucao.vl_unit_fatura        as ValorUnitFatura,
      _Devolucao.vl_total_fatura       as TotalFatura,
      _Devolucao.vl_bruto_fatura       as BrutoFatura,
      _Devolucao.aceita_val            as AceitaValores,
      _Devolucao.centro                as Centro,
      @Semantics.user.createdBy: true
      _Devolucao.created_by            as Created_By,
      @Semantics.systemDateTime.createdAt: true
      _Devolucao.created_at            as Created_At,
      @Semantics.user.lastChangedBy: true
      _Devolucao.last_changed_by       as Last_Changed_By,
      @Semantics.systemDateTime.lastChangedAt: true
      _Devolucao.last_changed_at       as Last_Changed_At,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      _Devolucao.local_last_changed_at as Local_Last_Changed_At,

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
      else  0 //Cinza
      end                              as CorSituacao,

      _TextoStatus.ddtext              as StatusText,

      case  _Devolucao.tipo_devolucao
      when '1' then 'Nf-e emitida pelo Cliente '
      when '2' then 'Retorno da Empresa'
      when '3' then 'Devolução E-Commerce B2C'
      when '4' then 'Devolução com complemento de imposto RS'
      else ' '
      end                              as TipoDevText,

      _Dev.OrdemDevolucao,


      _Reason._Text.SDDocumentReasonText,
      /* associations */
      _RefVal
}
where
      _Dev.OrdemDevolucao       is initial
  //      _Devolucao.ord_devolucao       is initial
  and _Devolucao.form_pagamento is not initial
