@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Impressão NF-e e MDF-e'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_CANHOTO_IMP_MASSA
  as select from    j_1bnfdoc                      as _Doc

    left outer join I_BR_NFItemDocumentFlowFirst_C as _BRNFItem  on _BRNFItem.BR_NotaFiscal = _Doc.docnum

    left outer join j_1bnflin                      as _Lin       on  _Lin.docnum = _Doc.docnum
                                                                 and _Lin.itmnum = _BRNFItem.BR_NotaFiscalItem

    left outer join I_BR_NFDocumentFlow_C          as _FlowNfe   on  _FlowNfe.BR_NotaFiscal     = _Doc.docnum
                                                                 and _FlowNfe.BR_NotaFiscalItem = _BRNFItem.BR_NotaFiscalItem

    left outer join vbak                           as _OrdVenda  on _OrdVenda.vbeln = _FlowNfe.OriginReferenceDocument

    left outer join j_1bnfepayment                 as _FormaPgto on _FormaPgto.docnum = _Doc.docnum

    left outer join ZI_SD_NF_ITEMS                 as _Items     on _Items.Docnum = _Doc.docnum

    left outer join I_BR_NFPartner                 as _Vendedor  on _Doc.docnum                      = _Vendedor.BR_NotaFiscal
                                                                 and(
                                                                   _Vendedor.BR_NFPartnerFunction    = 'ZI'
                                                                   or _Vendedor.BR_NFPartnerFunction = 'ZE'
                                                                 )

  association [0..1] to j_1bpagt as _FormaPgtoText on  _FormaPgtoText.spras = $session.system_language
                                                   and _FormaPgtoText.t_pag = _FormaPgto.t_pag

{
  key    _Doc.docnum                      as Docnum,
         @EndUserText.label: 'Ordem de Frete'
  key    _Items.Tor_id                    as TorId,
         _Doc.bukrs                       as Bukrs,
         _Doc.series                      as Series,
         _Doc.nfenum                      as Nfenum,
         _Doc.parid                       as Parid,
         _Doc.name1                       as Name1,
         _Lin.xped                        as PedidoCliente,
         _FormaPgto.t_pag                 as TPag,
         _FormaPgtoText.t_pagt            as TPagText,
         _Doc.waerk                       as Waerk,
         @Semantics.amount.currencyCode: 'Waerk'
         _Doc.nftot                       as NfTot,
         _Vendedor.BR_NFPartner           as BR_NFPartner,
         //_FlowNfe.ReferenceDocument       as ReferenceDocument,
         _FlowNfe.OriginReferenceDocument as OriginReferenceDocument,
         _OrdVenda.auart                  as Auart

}

where
       _Doc.direct =  '2'
  and  _Doc.manual <> 'X'
  and  _Doc.cancel <> 'X'
  and  _Doc.doctyp <> '5'
  and(
       _Doc.model  =  '55' //NF-e
    or _Doc.model  =  '58' // MDF-e
  )
