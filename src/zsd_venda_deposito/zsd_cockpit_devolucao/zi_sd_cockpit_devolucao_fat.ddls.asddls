@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit Devolução Fatura'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COCKPIT_DEVOLUCAO_FAT
  //  as select from I_SDDocumentProcessFlow as _FaturaItem
  as select from I_BillingDocumentItem  as _FaturaItem
    inner join   I_BillingDocumentBasic as _Fatura    on _Fatura.BillingDocument = _FaturaItem.BillingDocument
    inner join   ZI_SD_PARAM_TP_OV_DEV  as _TipoOrdem on _TipoOrdem.TpOrdem = _Fatura.BillingDocumentType
  association to ZI_SD_COCKPIT_DEVOLUCAO_OC    as _OrdemComp on _OrdemComp.DocumentoVendas = $projection.Fatura
  association to ZI_SD_COCKPIT_DEVOLUCAO_NFNUM as _Nfe       on _Nfe.DocOrigem = $projection.Fatura

{

           //  key  _FaturaItem.DocRelationshipUUID    as Documento,
           //       _FaturaItem.PrecedingDocument      as DocumentoVendas,
           //       _FaturaItem.SubsequentDocument     as Fatura,

  key      _FaturaItem.BillingDocument            as Fatura,
  key      min( _FaturaItem.BillingDocumentItem ) as ItemFatura,
           _FaturaItem.ReferenceSDDocument        as DocumentoVendas,
           _OrdemComp.OrdemComplementar           as OrdemComplementar,
           _OrdemComp.NfeComp                     as NfeComp,
           _OrdemComp.BloqueioFaturamento         as BloqueioFaturamento,
           @Semantics.amount.currencyCode: 'MoedaSD'
           @Aggregation.default:#SUM
           _Nfe.NfTotal                           as NfTotal,
           _Nfe.MoedaSD                           as MoedaSD,
           _Nfe.DocNfStatus,
           _Nfe.DocNf,
           _Nfe.Cancelado,
           _Nfe.NfeComp                           as Nfe

}
where
  _Fatura.BillingDocumentIsCancelled = ' '
group by
  _FaturaItem.BillingDocument,
  _FaturaItem.ReferenceSDDocument,
  _FaturaItem.BillingDocumentItem,
  _OrdemComp.OrdemComplementar,
  _OrdemComp.NfeComp,
  _OrdemComp.BloqueioFaturamento,
  _Nfe.NfTotal,
  _Nfe.MoedaSD,
  _Nfe.DocNfStatus,
  _Nfe.DocNf,
  _Nfe.Cancelado,
  _Nfe.NfeComp
