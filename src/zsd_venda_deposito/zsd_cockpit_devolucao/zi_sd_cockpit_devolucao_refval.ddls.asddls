@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit Devolução Referenciar e Validar'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COCKPIT_DEVOLUCAO_REFVAL
  as select from    ztsd_devolucao_i          as _Devolucao_i
    left outer join ztsd_devolucao            as _Devolucao  on _Devolucao.guid = _Devolucao_i.guid
    left outer join I_BillingDocument         as _Fatura     on _Devolucao_i.fatura = _Fatura.BillingDocument
    left outer join I_BillingDocumentItem     as _FaturaItem on  _Devolucao_i.fatura      = _FaturaItem.BillingDocument
                                                             and _Devolucao_i.item_fatura = _FaturaItem.BillingDocumentItem
    left outer join I_BillingDocumentTypeText as _Text       on  _Fatura.BillingDocumentType = _Text.BillingDocumentType
                                                             and _Text.Language              = $session.system_language
  association        to parent ZI_SD_COCKPIT_DEVOLUCAO_GERDEV as _GeracaoDev on $projection.Guid = _GeracaoDev.Guid
  association [0..1] to I_SDDocumentReason                    as _Reason     on $projection.Motivo = _Reason.SDDocumentReason
  association [0..1] to I_SDDocumentReason                    as _ReasonFat  on _ReasonFat.SDDocumentReason = _FaturaItem.SDDocumentReason

{

  key _Devolucao_i.guid                as Guid,
  key _Devolucao_i.item                as Item,
      _Devolucao.local_negocio         as LocalNegocio,
      _Devolucao.tipo_devolucao        as TpDevolucao,
      _Devolucao.regiao                as Regiao,
      _Devolucao.ano                   as Ano,
      _Devolucao.mes                   as Mes,
      _Devolucao.cnpj                  as Cnpj,
      _Devolucao.modelo                as Modelo,
      _Devolucao.serie                 as Serie,
      _Devolucao.numero_nfe            as NumNFe,
      _Devolucao.nro_aleatorio         as NroAleatorio,
      _Devolucao.digito_verific        as DigitoVerific,
      _Devolucao.chaveacesso           as ChaveAcesso,
      _Devolucao.transportadora        as Transportadora,
      _Devolucao.motorista             as Motorista,
      _Devolucao.motivo                as Motivo,
      _Devolucao.form_pagamento        as MeioPagamento,
      _Devolucao.situacao              as Situacao,
      @Semantics.amount.currencyCode: 'CodMoeda'
      _Devolucao.valor_totalnfe        as ValorTotal,
      _Devolucao.dt_lancamento         as DtLancamento,
      _Devolucao.cliente               as Cliente,
      _Devolucao.centro                as Centro,

      _Devolucao_i.material            as Material,
      _Devolucao_i.texto_material      as TextoMaterial,
      _Devolucao_i.ean                 as CodEan,
      _Devolucao_i.quantidade_nfe      as Quantidade,
      _Devolucao_i.unmedida_nfe        as UnMedida,
      @Semantics.amount.currencyCode: 'CodMoeda'
      _Devolucao_i.valor_unit          as ValorUnit,
      _Devolucao_i.cod_moeda           as CodMoeda,
      _Devolucao_i.fatura              as Fatura,
      _Devolucao_i.item_fatura         as ItemFatura,
      _Devolucao_i.nfe_fatura          as NFe,
      _Devolucao_i.data_fatura         as DataFatura,
      _Devolucao_i.un_fatura           as UnMedidaFatura,
      _Devolucao_i.txt_mat_fatura      as TextoMaterialFatura,
      @Semantics.quantity.unitOfMeasure : 'UnMedidaFatura'
      _Devolucao_i.qtd_fatura          as QuantidadeFatura,
      _Devolucao_i.vl_unit_fatura      as ValorUnitFatura,
      _Devolucao_i.vl_total_fatura     as TotalFatura,
      _Devolucao_i.vl_bruto_fatura     as BrutoFatura,
      _Devolucao_i.aceita_val          as AceitaValores,

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
      case  _Devolucao.tipo_devolucao
      when '1' then 'Nf-e emitida pelo Cliente '
      when '2' then 'Retorno da Empresa'
      when '3' then 'Devolução E-Commerce B2C'
      when '4' then 'Devolução com complemento de imposto RS'
      else ' '
      end                              as TipoDevText,
      _Fatura.BillingDocumentType,
      _Text.BillingDocumentTypeName,
      _FaturaItem.SDDocumentReason,
      _ReasonFat._Text.SDDocumentReasonText as MotivoFaturaText,
      @Semantics.amount.currencyCode: 'CodMoeda'
      _Devolucao_i.vl_sugestao         as SugestaoValor,
      //      cast( DATS_ADD_MONTHS ($session.system_date,-12,'UNCHANGED') as abap.dats(8)) as PeriodoDesde,
      //      cast( $session.system_date as abap.dats(8))                                   as PeriodoAte,

      /* associations */
      _GeracaoDev

}
