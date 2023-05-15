@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Fluxo de remessa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_MONITOR_REM 
  as select from    I_SDDocumentProcessFlow               as _SDDocumentFlow

    left outer join ZI_SD_MONITOR_TOR( p_tipo_doc : '73',
                                       p_catg_doc : 'TO') as _OrdemFrete   on _OrdemFrete.Remessa = _SDDocumentFlow.SubsequentDocument

    left outer join ZI_SD_MONITOR_TOR( p_tipo_doc : '114',
                                       p_catg_doc : 'FU') as _UnidadeFrete on _UnidadeFrete.Remessa = _SDDocumentFlow.SubsequentDocument and _UnidadeFrete.lifecycle <> '10'

  association to I_DeliveryDocument as _Delivery   on _Delivery.DeliveryDocument = $projection.SubsequentDocument
  //  association to ZI_SD_MONITOR_TOR  as _Tor        on _Tor.Remessa = $projection.SubsequentDocument
  association to ZI_SD_MONITOR_FAT  as _FlowFatura on _FlowFatura.PrecedingDocument = $projection.SubsequentDocument
  //    and _FlowFatura.SubsequentDocumentItem = $projection.PrecedingDocumentItem

{

  key _SDDocumentFlow.DocRelationshipUUID,

      //Preceding
  key _SDDocumentFlow.PrecedingDocument, 
  key min( _SDDocumentFlow.PrecedingDocumentItem  ) as PrecedingDocumentItem ,
      _SDDocumentFlow.PrecedingDocumentCategory,

      //Subsequent
      _SDDocumentFlow.SubsequentDocument,
      min( _SDDocumentFlow.SubsequentDocumentItem ) as SubsequentDocumentItem,
      _SDDocumentFlow.SubsequentDocumentCategory,
      case
          when _SDDocumentFlow.SubsequentDocument is not null then _SDDocumentFlow.SubsequentDocument
          else cast( '0000000000' as vbeln )
      end                                                as Remessa,
      _Delivery.CreationDate                             as CreationDate,
      _Delivery.CreationTime                             as CreationTime,
      _Delivery.PickingDate                              as PickingDate, 
      _Delivery.PickingTime                              as PickingTime,
      _Delivery.ActualGoodsMovementDate                  as ActualGoodsMovementDate,
      _Delivery.ActualGoodsMovementTime                  as ActualGoodsMovementTime,
      _Delivery.ShippingPoint                            as ShippingPoint,
      _OrdemFrete.DocumentoFrete                         as OrdemFrete, 
      _OrdemFrete.ActualDate                             as ActualDate,
      cast ( _OrdemFrete.ActualDate as abap.char( 20 ) ) as ActualDateSaida,

      //case when (cast ( _OrdemFrete.ActualDate as abap.char( 20 ) ) <> '0')
      //then TSTMP_TO_DATS(_OrdemFrete.ActualDate,abap_system_timezone( $session.client,'INITIAL' ),$session.client,'INITIAL')
      //else '' end as DateSaida,
      
      //TSTMP_TO_DATS(_OrdemFrete.ActualDate,abap_system_timezone( $session.client,'INITIAL' ),
                     //$session.client,'INITIAL')             as DateSaida,
      
      //case when (cast ( _OrdemFrete.ActualDate as abap.char( 20 ) ) <> '0')
      //then tstmp_to_tims( _OrdemFrete.ActualDate,abap_system_timezone( $session.client,'INITIAL' ),$session.client,'INITIAL' )
      //else '' end as HoraSaida,
      
      //tstmp_to_tims( _OrdemFrete.ActualDate,abap_system_timezone( $session.client,'INITIAL' ),
      //$session.client,'INITIAL' )                           as HoraSaida,
      _OrdemFrete.DateSaida,
      _OrdemFrete.HoraSaida,
      
      //      cast ( '' as abap.char( 20 ) )    as ActualDateSaida,
      _UnidadeFrete.DocumentoFrete                       as UnidadeFrete,
      case
          when _FlowFatura.SubsequentDocument is not null then _FlowFatura.SubsequentDocument
          else cast( '0000000000' as vbeln )
      end                                                as Fatura,

      case
          when _FlowFatura.BR_NotaFiscal is not null then _FlowFatura.BR_NotaFiscal
//          else cast( '0000000000' as j_1bdocnum )
      end                                                as BR_NotaFiscal,
      _FlowFatura.BR_NFPartnerRegionCode,
      _FlowFatura.BR_NFIsPrinted,
      _FlowFatura.BR_NFeDocumentStatus,
      case
        when _FlowFatura.BR_NFeNumber is not null then _FlowFatura.BR_NFeNumber
        else cast( '000000000' as logbr_nfnum9 )
      end                                                as BR_NFeNumber,
      _FlowFatura.BillingDocumentIsCancelled,
      _FlowFatura.CreationDate                           as CreationDateFatura,
      _FlowFatura.CreationTime                           as CreationTimeFatura

}
where
      _SDDocumentFlow.SubsequentDocumentCategory = 'J'
//  and _SDDocumentFlow.SubsequentDocumentItem     = '000010'
group by
  _SDDocumentFlow.DocRelationshipUUID,

  //Preceding
  _SDDocumentFlow.PrecedingDocument,
//  _SDDocumentFlow.PrecedingDocumentItem,
  _SDDocumentFlow.PrecedingDocumentCategory,

  //Subsequent
  _SDDocumentFlow.SubsequentDocument,
//  _SDDocumentFlow.SubsequentDocumentItem,
  _SDDocumentFlow.SubsequentDocumentCategory,
  _Delivery.CreationDate,
  _Delivery.CreationTime,
  _Delivery.PickingDate,
  _Delivery.PickingTime,
  _Delivery.ActualGoodsMovementDate,
  _Delivery.ActualGoodsMovementTime, 
  _Delivery.ShippingPoint,
  _OrdemFrete.DocumentoFrete,
  _OrdemFrete.ActualDate,
  _UnidadeFrete.DocumentoFrete,
  _FlowFatura.DocRelationshipUUID,
  _FlowFatura.SubsequentDocument,
  _FlowFatura.BR_NotaFiscal,
  _FlowFatura.BR_NFPartnerRegionCode,
  _FlowFatura.BR_NFIsPrinted,
  _FlowFatura.BR_NFeDocumentStatus,
  _FlowFatura.BR_NFeNumber,
  _FlowFatura.BillingDocumentIsCancelled,
  _FlowFatura.CreationDate,
  _FlowFatura.CreationTime,
  _OrdemFrete.DateSaida,
  _OrdemFrete.HoraSaida
