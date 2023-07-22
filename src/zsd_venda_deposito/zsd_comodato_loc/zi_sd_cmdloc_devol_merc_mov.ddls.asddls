@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS para ZCLSD_CMDLOC_DEVOL_MERCADORIA'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CMDLOC_DEVOL_MERC_MOV
  as select from    I_SalesContract               as contrato

    left outer join I_SalesContractItem           as _contrato_item on _contrato_item.SalesContract = contrato.SalesContract

    left outer join ZI_SD_CMDLOC_DEVOL_MERC_MOV_L as _contrato_vbak on _contrato_vbak.SalesContract = contrato.SalesContract

    left outer join vbak                          as _vbak          on _vbak.vbeln = _contrato_vbak.SalesDocument

    left outer join ZI_SD_COCKPIT_REM_VALID       as _link_remessa  on _link_remessa.OrdemVenda = _vbak.vbeln

    left outer join ZI_SD_COCKPIT_FAT_VALID       as _link_fatura   on _link_fatura.Remessa = _link_remessa.Remessa

    left outer join I_BR_NFItem                   as _nf_item_saida on _nf_item_saida.BR_NFSourceDocumentNumber = _link_fatura.DocFatura

    left outer join I_BR_NFDocument               as _nf_saida      on _nf_saida.BR_NotaFiscal = _nf_item_saida.BR_NotaFiscal

    left outer join ZI_SD_COCKPIT_NFE_ENTRADA     as _nf_entrada    on _nf_entrada.Nfenum = _nf_saida.BR_NFeNumber

{
  key contrato.SalesContract           as SalesContract,
      _vbak.vbeln                      as SalesDocument,
      _link_remessa.Remessa            as DeliveryDocument,
      contrato.PurchaseOrderByCustomer as Solicitacao,

      case when contrato.DistributionChannel = '10'
           then 'Macro'
           else 'Micro'
           end                         as TpOperacao,

      _nf_saida.BR_NotaFiscal          as DocnumNfeSaida,
      _nf_entrada.Docnum               as DocnumEntrada,
      _link_fatura.DocFatura           as DocFatura,

      case when contrato.DistributionChannel = '10'
            then _nf_entrada.Werks
            else _contrato_item.Plant
            end                        as CentroDestino,
      _contrato_item.Plant             as CentroOrigem,

      _nf_saida.BR_NFeNumber           as NfeSaida
}
