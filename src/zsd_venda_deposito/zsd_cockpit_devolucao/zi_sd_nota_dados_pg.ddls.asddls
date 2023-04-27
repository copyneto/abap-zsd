@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Nota fiscal e dados pagamnento.'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_NOTA_DADOS_PG
  as select from ztsd_devolucao as _Devol
{
  key _Devol.guid              as Guid,
      _Devol.local_negocio     as LocalNegocio,
      _Devol.tipo_devolucao    as TipoDevolucao,
      _Devol.numero_nfe        as NumeroNfe,
      _Devol.ordem             as Ordem,
      _Devol.cnpj              as Cnpj,
      _Devol.dt_logistica      as DtLogistica,
      _Devol.motivo            as motivo,
      _Devol.dt_administrativo as DtAdministrativo,
      _Devol.form_pagamento    as FormPagamento,
      _Devol.banco             as Banco,
      _Devol.denomi_banco      as DenomiBanco,
      _Devol.agencia           as Agencia,
      _Devol.conta             as Conta,
      _Devol.prot_ocorrencia   as protOcorrencia

}
