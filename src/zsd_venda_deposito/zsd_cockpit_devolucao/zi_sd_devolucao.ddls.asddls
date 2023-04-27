@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cadastro devoluções clientes'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_DEVOLUCAO
  as select from ztsd_devolucao
{
      @UI.hidden: true
  key guid                  as Guid,
      @EndUserText: { label: 'Local de negócio ',
           quickInfo: 'Local de negócio ' }
      local_negocio         as LocalNegocio,
      @EndUserText: { label: 'Tipo de devolução ',
           quickInfo: 'Tipo de devolução ' }
      tipo_devolucao        as TipoDevolucao,
      @EndUserText: { label: 'Região',
           quickInfo: 'Região' }
      regiao                as Regiao,
      @EndUserText: { label: 'Ano',
           quickInfo: 'Ano' }
      ano                   as Ano,
      @EndUserText: { label: 'Mês',
           quickInfo: 'Mês' }
      mes                   as Mes,
      @EndUserText: { label: 'Modelo',
           quickInfo: 'Modelo' }
      modelo                as Modelo,
      @EndUserText: { label: 'Série',
           quickInfo: 'Série' }
      serie                 as Serie,
      @EndUserText: { label: 'Número da NF-e',
           quickInfo: 'Número da NF-e' }
      numero_nfe            as NumeroNfe,
      @EndUserText: { label: 'Dígito verificador',
           quickInfo: 'Dígito verificador' }
      digito_verific        as DigitoVerific,
      @EndUserText: { label: 'CNPJ',
           quickInfo: 'CNPJ' }
      cnpj                  as Cnpj,
      case when ztsd_devolucao.cnpj is initial then ''
          else concat( substring(ztsd_devolucao.cnpj, 1, 2),
               concat( '.',
               concat( substring(ztsd_devolucao.cnpj, 3, 3),
               concat( '.',
               concat( substring(ztsd_devolucao.cnpj, 6, 3),
               concat( '/',
               concat( substring(ztsd_devolucao.cnpj, 9, 4),
               concat( '-',  substring(ztsd_devolucao.cnpj, 13, 2) ) ) ) ) ) ) ) )
      end                   as CNPJText,
      @EndUserText: { label: 'Cliente',
           quickInfo: 'Cliente' }
      cliente               as Cliente,
      @EndUserText: { label: 'Data logística',
           quickInfo: 'Data logística' }
      dt_logistica          as DtLogistica,
      @EndUserText: { label: 'Data administrativo',
           quickInfo: 'Data administrativo' }
      dt_administrativo     as DtAdministrativo,
      @EndUserText: { label: 'Motivo',
           quickInfo: 'Motivo' }
      motivo                as Motivo,
      @EndUserText: { label: 'Forma de pagamento',
           quickInfo: 'Forma de pagamento' }
      form_pagamento        as FormPagamento,
      @EndUserText: { label: 'Senha autorização',
           quickInfo: 'Senha autorização' }
      senha_autorizacao     as SenhaAutorizacao,
      @EndUserText: { label: 'Data de lançamento',
           quickInfo: 'Data de lançamento' }
      dt_lancamento         as DtLancamento,
      @EndUserText: { label: 'Hora de lançamento',
           quickInfo: 'Hora de lançamento' }
      hr_lancamento         as HrLancamento,
      @EndUserText: { label: 'Ordem',
           quickInfo: 'Ordem' }
      ordem                 as Ordem,
      @EndUserText: { label: 'Centro',
           quickInfo: 'Centro' }
      centro                as Centro,
      @EndUserText: { label: 'Data criação',
           quickInfo: 'Data criação' }
      dt_criacao            as DtCriacao,
      @EndUserText: { label: 'Hora criação',
           quickInfo: 'Hora criação' }
      hr_criacao            as HrCriacao,
      @EndUserText: { label: 'Agente de frete',
           quickInfo: 'Agente de frete' }
      ag_frete              as AgFrete,
      @EndUserText: { label: 'Placa',
           quickInfo: 'Placa' }
      placa                 as Placa,
      @EndUserText: { label: 'Motorista',
           quickInfo: 'Motorista' }
      motorista             as Motorista,
      @EndUserText: { label: 'Tipo de expedição',
           quickInfo: 'Tipo de expedição' }
      tipo_expedicao        as TipoExpedicao,
      @EndUserText: { label: 'Transportadora',
           quickInfo: 'Transportadora' }
      transportadora        as Transportadora,
      @EndUserText: { label: 'Ordem de devolução',
           quickInfo: 'Ordem de devolução' }
      ord_devolucao         as OrdDevolucao,
      material              as Material,
      @EndUserText: { label: 'Situação',
      quickInfo: 'Situação' }
      situacao              as Situacao,
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
