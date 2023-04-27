@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cadastro WEB - SAP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_SINT_PROCES
  as select from ztsd_sint_proces
{
  key id                    as Id,
  key promocao              as Promocao,
      nome                  as Nome,
      cpf                   as Cpf,
      endereco              as Endereco,
      numero                as Numero,
      complemento           as Complemento,
      referencia            as Referencia,
      cep                   as Cep,
      bairro                as Bairro,
      cidade                as Cidade,
      estado                as Estado,
      email                 as Email,
      ddd                   as Ddd,
      telefone              as Telefone,
      codigo                as Codigo,
      clube                 as Clube,
      maquina               as Maquina,
      nr_serie              as NrSerie,
      dt_compra             as DtCompra,
      local_compra          as LocalCompra,
      end_loja              as EndLoja,
      nota_fiscal           as NotaFiscal,
      dt_cadastro           as DtCadastro,
      dt_edicao             as DtEdicao,
      status                as Status,
      case  status
            when '1' then 'Pendente'
            when '2' then 'Concluído'
            when '3' then 'Erro'
            else'Pendente'
           end              as StatusText,

      case status
      when '1' then 0 --Cinza
      when '2' then 3 --Verde
      when '3' then 1 --Vermelho
      else 0 --Cinza
      end                   as StatusColor,

      observacao            as Observacao,

      equipe_status         as EquipeStatus,
      case equipe_status
            when '1' then 'Pendente'
            when '2' then 'Concluído'
            when '3' then 'Erro'
            else 'Pendente'
       end                  as EquipeStatustxt,
      case equipe_status
      when '1' then 0 --Verde
      when '2' then 3 --Vermelho
      when '3' then 1
      else 0 --Cinza
      end                   as EquipeStatuscolor,

      equipe_obs            as EquipeObs,
      equipe_rastreio       as EquipeRastreio,
      equipe_nf             as EquipeNf,
      ip                    as Ip,
      user_agente           as UserAgente,
      cadastro_sac          as CadastroSac,
      opt_news              as OptNews,
      dt_criacao            as DtCriacao,
      hr_criacao            as HrCriacao,
      dt_registro           as DtRegistro,
      hr_objto_criado       as HrObjtoCriado,
      nome_resp_objto       as NomeRespObjto,
      cod_eliminacao        as CodEliminacao,
      bp                    as Bp,
      dt_criacao_cliente    as DtCriacaoCliente,
      nome_resp_cliente     as NomeRespCliente,
      status_bp             as StatusBp,
      case status_bp
            when '1' then 'Pendente'
            when '2' then 'Concluído'
            when '3' then 'Erro'
            else'Pendente'
      end                   as StatusBptext,
      case status_bp
      when '1' then 0 --Verde
      when '2' then 3 --Vermelho
      when '3' then 1
      else 0 --Cinza
      end                   as StatusBpColor,

      cod_maq_sap           as CodMaqSap,
      dt_criacao_equip      as DtCriacaoEquip,
      respons_criacao_equip as ResponsCriacaoEquip,
      status_criacao_equip  as StatusCriacaoEquip, 
      
      case status_criacao_equip 
            when '1' then 'Pendente'
            when '2' then 'Concluído'
            when '3' then 'Erro'
            else'Pendente'
      end                   as StatusCriacaoEquiptext,

      case status_criacao_equip
      when '1' then 0 --Verde
      when '2' then 3 --Vermelho
      when '3' then 1
      else 0 --Cinza
      end                   as StatusCriacaoEquipColor,

      doc_ov                as DocOv,
      status_ov              as StatusOv,
      case status_ov
            when '1' then 'Pendente'
            when '2' then 'Concluído'
            when '3' then 'Erro'
            else'Pendente'
      end                   as StatusOvtext,

      case status_ov
      when '1' then 0 --Verde
      when '2' then 3 --Vermelho
      when '3' then 1
      else 0 --Cinza
      end                   as StatusOvColor,

      forn                  as Forn,
      status_forn_sap       as StatusFornSap,
      case status_forn_sap
            when '1' then 'Pendente'
            when '2' then 'Concluído'
            when '3' then 'Erro'
            else'Pendente'
      end                   as StatusFornSaptext,

      case status_forn_sap
      when '1' then 0 --Verde
      when '2' then 3 --Vermelho
      when '3' then 1
      else 0 --Cinza
      end                   as StatusFornSapColor,

      doc_fat               as DocFat,
      status_fat            as StatusFat,
      case status_fat
            when '1' then 'Pendente'
            when '2' then 'Concluído'
            when '3' then 'Erro'
            else'Pendente'
      end                   as StatusFattext,

      case status_fat
      when '1' then 0 --Verde
      when '2' then 3 --Vermelho
      when '3' then 1 
      else 0 --Cinza
      end                   as StatusFatColor,

      nr_nfe                as NrNfe,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt
}
