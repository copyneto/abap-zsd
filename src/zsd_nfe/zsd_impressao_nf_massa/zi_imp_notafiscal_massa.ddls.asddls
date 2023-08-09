@AbapCatalog.sqlViewName: 'ZEIMPNFMS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'Impressão Nota Fiscal em Massa'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view ZI_IMP_NOTAFISCAL_MASSA
  as select from           /scmtms/d_torrot as _Torrot            
    inner join             /scmtms/d_tordrf            as _TorDrf          on  _TorDrf.parent_key  = _Torrot.db_key
                                                                          and  _TorDrf.btd_tco = '73'

    inner join             /scmtms/d_torite            as _OrdemFreteItem on  _OrdemFreteItem.parent_key      = _Torrot.db_key
                                                                          and _OrdemFreteItem.main_cargo_item = 'X'
                                                                          and _OrdemFreteItem.base_btd_tco    = '73'

    left outer join        /scmtms/d_torsts            as _Carga          on _Carga.succ_stop_key = _OrdemFreteItem.des_stop_key

    left outer join        I_DeliveryDocument          as _Remessa        on _Remessa.DeliveryDocument = right(
      _OrdemFreteItem.base_btd_id, 10
    )
    inner join             I_DeliveryDocumentItem      as _RemessaItem    on  _RemessaItem.DeliveryDocument      =  _Remessa.DeliveryDocument
                                                                          and _RemessaItem.ItemIsBillingRelevant <> ' '

    left outer join        I_BR_NFDocumentFlow_C       as _NFDocumentFlow on  _NFDocumentFlow.PredecessorReferenceDocument = _RemessaItem.DeliveryDocument
                                                                          and _NFDocumentFlow.PredecessorReferenceDocItem  = _RemessaItem.DeliveryDocumentItem
    left outer join        I_BR_NFDocument             as _NFDocument     on  _NFDocument.BR_NotaFiscal        =  _NFDocumentFlow.BR_NotaFiscal
                                                                          and _NFDocument.BR_NFeDocumentStatus =  '1'
                                                                          and _NFDocument.BR_NFIsCanceled      <> 'X'
                                                                          and _NFDocument.BR_NFDocumentType    <> '5'


    left outer to one join ZI_IMP_NOTAFISCAL_MASSA_ITM as _Comp           on _Comp.Docnum = _NFDocument.BR_NotaFiscal

{
  key _Comp.Docnum          as Docnum,
      _Comp.Refkey          as Refkey,
      _Comp.Werks           as Werks,
      _Torrot.tor_id        as Tor_id,
      _Carga.successor_id   as StopOrder,
      _Comp.Fkart           as Fkart,
      _Comp.Vbtyp           as Vbtyp,
      _Comp.Belnr           as Belnr
}
where
  _Torrot.tor_cat = 'TO'
group by
  _Comp.Docnum,
  _Comp.Refkey,
  _Comp.Werks,
  _Torrot.tor_id,
  _Carga.successor_id,
  _Comp.Fkart,
  _Comp.Vbtyp,
  _Comp.Belnr
