@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Fluxo ordem de transporte'
define root view entity ZI_TM_FLUXO_ORDEM_TRANSPORTE 
  as select from    /scmtms/d_torrot          as OrdemFrete
    inner join      /scmtms/d_torite          as OrdemFreteItem      on  OrdemFreteItem.parent_key   = OrdemFrete.db_key
                                                                     and OrdemFreteItem.base_btd_tco = '73'
    left outer join I_DeliveryDocument        as Remessa             on Remessa.DeliveryDocument = right(
      OrdemFreteItem.base_btd_id, 10
    )
    inner join      I_DeliveryDocumentItem    as RemessaItem         on  RemessaItem.DeliveryDocument      =  Remessa.DeliveryDocument
                                                                     and RemessaItem.DeliveryDocumentItem  = right(
      OrdemFreteItem.base_btditem_id, 6
    )
                                                                     and RemessaItem.ItemIsBillingRelevant <> ' '
    left outer join I_BillingDocItemAnalytics as BillingDocumentItem on  BillingDocumentItem.ReferenceSDDocument        = Remessa.DeliveryDocument
                                                                     and BillingDocumentItem.ReferenceSDDocumentItem    = RemessaItem.DeliveryDocumentItem
                                                                     and BillingDocumentItem.BillingDocumentIsCancelled = ' '
                                                                     and BillingDocumentItem.CancelledBillingDocument   = ' '

    left outer join /scmtms/d_torite          as Veiculo             on  Veiculo.parent_key = OrdemFrete.db_key
                                                                     and Veiculo.item_type  = 'TRUC'
//    left outer join /scmtms/d_torexe          as Execucao            on Execucao.parent_key = OrdemFrete.db_key
    left outer join /scmtms/d_torpty          as Parceiros           on Parceiros.parent_key = OrdemFrete.db_key
    left outer join I_BusinessPartner         as Motorista           on Motorista.BusinessPartner = Parceiros.party_id
    left outer join /scmtms/d_torsts          as Paradas             on Paradas.succ_stop_key = OrdemFreteItem.des_stop_key
    left outer join I_BR_NFItem               as NFItens             on  NFItens.BR_NFSourceDocumentNumber = BillingDocumentItem.BillingDocument
                                                                     and NFItens.BR_NFSourceDocumentItem   = BillingDocumentItem.BillingDocumentItem
    left outer join I_BR_NFDocument           as NFDocument          on  NFDocument.BR_NotaFiscal     =  NFItens.BR_NotaFiscal
                                                                     and NFDocument.BR_NFIsCanceled   =  ' '
                                                                     and NFDocument.BR_NFDocumentType <> '5'

{
  key OrdemFrete.db_key                                              as TransportationOrderKey,
      OrdemFrete.tor_id                                              as TransportationOrder,
      tstmp_to_dats( OrdemFrete.created_on,
                     abap_system_timezone( $session.client,'NULL' ),
                     $session.client, 'NULL' )                       as CreatedOn,
      OrdemFrete.created_by                                          as CreatedBy,
      Motorista.BusinessPartner                                      as Motorista,
      Motorista.BusinessPartnerFullName                              as NomeMotorista,
      Veiculo.platenumber                                            as PlacaVeiculo,
      NFDocument.BR_NotaFiscal                                       as NotaFiscalDoc,
      NFItens.BR_NotaFiscalItem                                      as NotaFiscalDocItem,
      cast( right( OrdemFreteItem.base_btd_id, 10 ) as vbeln_vl )    as DeliveryDocument,
      cast( right( OrdemFreteItem.base_btditem_id, 6 ) as posnr_vl ) as DeliveryDocItem,
      BillingDocumentItem.BillingDocument                            as InvoiceDocument,
      BillingDocumentItem.BillingDocumentItem                        as InvoiceDocItem,
      NFDocument.BR_NFeNumber                                        as NotaFiscal,
      NFDocument.BR_NFPartnerName1                                   as Cliente,
      NFDocument.CreationDate                                        as DataEmissao,
      NFItens.Material                                               as Material,
      NFItens.MaterialName                                           as MaterialName,
      NFItens.QuantityInBaseUnit                                     as Quantity,
      NFItens.BaseUnit                                               as QuantityUnit,
      Paradas.successor_id                                           as StopOrder,
      OrdemFreteItem.item_sort_id                                    as ItemSort,
      OrdemFreteItem.net_wei_val                                     as FreightOrderWeight,
      OrdemFreteItem.net_wei_uni                                     as FreightOrderWeightUnit
//      Execucao.event_code                                            as EventName

}
where
  OrdemFrete.tor_cat = 'TO'
