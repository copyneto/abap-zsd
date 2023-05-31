@AbapCatalog.sqlViewName: 'ZV_SD_CR_CP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit Contratos - Análise CR/CP'
define view ZI_SD_CR_CP_CTR
  as select from           ZI_SD_COMODATO_LAST_PARC as fpla_princ

    inner join             fpla                                 on fpla.fplnr = fpla_princ.Fplnr
    inner join             fplt                                 on fplt.fplnr = fpla.fplnr

    inner join             ZI_SD_COMODATO_ITENS     as Itens    on  Itens.Contrato = fpla_princ.vbeln
                                                                and Itens.Parcela  = fplt.fpltr

    left outer to one join I_BillingDocumentItem    as Fatura   on Fatura.BillingDocument = fpla.vbeln

    left outer join        I_SalesDocumentItem      as Ordem    on  Ordem.SalesDocument     = Fatura.SalesDocument
                                                                and Ordem.SalesDocumentItem = Fatura.SalesDocumentItem

    left outer join        I_SalesContractItem      as Contrato on  Contrato.SalesContract     = Ordem.ReferenceSDDocument
                                                                and Contrato.SalesContractItem = Ordem.ReferenceSDDocumentItem

    left outer join        ZI_SD_COMODATO_LAST_VBFA as Vbfa     on  Vbfa.vbelv = fpla.vbeln
                                                                and Vbfa.fpltr = fplt.fpltr

    left outer join        bseg                     as Bseg     on bseg.vbeln = Vbfa.vbeln

    left outer join        vbrk                     as vbrk_ref on vbrk_ref.vbeln = Vbfa.vbeln

    left outer join        bsik                     as Bsik     on bsik.xblnr = vbrk_ref.xblnr

    left outer join        bsid                     as Bsid     on bsid.xblnr = vbrk_ref.xblnr

  //    left outer join        acdoca                   as acdoca_d on  acdoca_d.rbukrs   = vbrk_ref.bukrs
  //                                                                and acdoca_d.gjahr    = substring(
  //      vbrk_ref.fkdat, 1, 4
  //    )
  //                                                                and acdoca_d.koart    = 'D'
  //                                                                and acdoca_d.kunnr    = vbrk_ref.kunag
  //                                                                and acdoca_d.zuonr    = vbrk_ref.zuonr
  //                                                                and acdoca_d.xtruerev is initial
  //
  //    left outer join        acdoca                   as acdoca_k on  acdoca_k.rbukrs   = vbrk_ref.bukrs
  //                                                                and acdoca_k.gjahr    = substring(
  //      vbrk_ref.fkdat, 1, 4
  //    )
  //                                                                and acdoca_k.koart    = 'K'
  //                                                                and acdoca_k.zuonr    = vbrk_ref.zuonr
  //                                                                and acdoca_k.xtruerev is initial
{
      //  key Contrato.ReferenceSDDocument as Contrato,
  key fpla_princ.vbeln           as Contrato,
  key fpla.fplnr                 as Parcela,
  key fplt.fpltr                 as ParcelaItem,
      Ordem.SalesDocument        as Ordem,
      Fatura.ReferenceSDDocument as Remessa,
      Fatura.BillingDocument     as Fatura,
      fplt.afdat                 as Datafaturamento,
      //      acdoca_d.belnr             as DocFinFatura,
      //      acdoca_d.bldat             as DataGeracao,
      //      acdoca_d.zuonr             as Atribuicao,
      vbrk_ref.erdat             as DataGeracao,
      vbrk_ref.xblnr             as DocFinFatura,
      bseg.belnr                 as Atribuicao,
      bseg.netdt                 as Vencimento,
      @Semantics.amount.currencyCode: 'Moeda'
      //      acdoca_d.osl               as Valor,
      Itens.Fakwr                as Valor,
      //      acdoca_d.rocur             as Moeda,
      Itens.Waers                as Moeda,
      //      acdoca_k.bldat             as DataCriacao,
      //      acdoca_k.belnr             as DocFinRecebimento
      //      bseg.augcp                 as DataCriacao,
      //      bseg.augbl                 as DocFinRecebimento,
      bsik.belnr                 as DocFinRecebimento,
      //      bsik.bldat                 as DataCriacao
      bsid.bldat                 as DataCriacao
}
where
  fplt.fakwr <> 0
