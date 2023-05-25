//@AbapCatalog.sqlViewName: ''
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
//@AccessControl.authorizationCheck: #CHECK
//@EndUserText.label: 'CDS Interf. - Fluxo de remessa'

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interf. - Fluxo de remessa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZI_SD_STATUS_REM
  as select from ZI_SD_STATUS_FILTRO_REMESSA as VBFA_Filt

  //    left outer join I_SDDocumentProcessFlow     as VBFA on  VBFA_Filt.PrecedingDocument  = VBFA.PrecedingDocument
  //                                                        and VBFA_Filt.SubsequentDocument = VBFA.SubsequentDocument


  //association to I_DeliveryDocument as _Delivery   on _Delivery.DeliveryDocument    = $projection.SubsequentDocument
  association [0..1] to ZI_SD_STATUS_SHIP as _Exped      on _Exped.DeliveryDocument = $projection.DeliveryDocument
  //    on _Exped.ShippingCondition      = $pojection.shippingcondition

  association [0..1] to ZI_SD_STATUS_TOR  as _Tor        on _Tor.Remessa = $projection.DeliveryDocument

  //association [0..1] to ZI_SD_STATUS_FAT   as _FlowFatura on _FlowFatura.PrecedingDocument = $projection.SubsequentDocument

  association [0..1] to ZI_SD_STATUS_FAT  as _FlowFatura on _FlowFatura.PrecedingDocument = $projection.DeliveryDocument
  //                                                         and _FlowFatura.SubsequentDocument = $projection.DeliveryDocument

{

  key VBFA_Filt.PrecedingDocument,
  key VBFA_Filt.SubsequentDocument                                              as DeliveryDocument,
      VBFA_Filt.PrecedingDocumentCategory,
      VBFA_Filt.SubsequentDocumentCategory,
//            VBFA_Filt.CreationDate,
      _FlowFatura.SubsequentDocument                                            as Fatura,
      _FlowFatura.CreationDate                                                  as CreationDateFatura,
      //      _FlowFatura.BillingDocument, //foi trocado
      _FlowFatura.SubsequentDocumentCategory                                    as DocFatCateg,
      _FlowFatura.BR_NotaFiscal,
      _FlowFatura.BR_CFOPCode,
      _FlowFatura.BR_NFeNumber,
      _FlowFatura.BR_NFAuthenticationDate,
      _FlowFatura.BR_NFNetAmount,
      _FlowFatura.BR_NFPostingDate,
      @Semantics.quantity.unitOfMeasure: 'HeaderWeightUnit'
      _FlowFatura.HeaderNetWeight,
      @Semantics.quantity.unitOfMeasure: 'HeaderWeightUnit'
      _FlowFatura.HeaderGrossWeight,
      _FlowFatura.BR_NFIsPrinted,
      _FlowFatura.HeaderWeightUnit,
      _Tor.OrdemFrete                                                           as OrdemFrete,
      _Tor.Remessa                                                              as Remessa,

//     cast( concat( concat(substring( _Tor.DataOF, 7, 2 ), '.'),
//             concat(substring( _Tor.DataOF, 5, 2 ), 
//             concat('.', substring( _Tor.DataOF, 1, 4 ))) ) as abap.dats(8) ) as CreationDate, 
     cast( concat(substring( _Tor.DataOF, 1, 4 ),
             concat(substring( _Tor.DataOF, 5, 2 ), 
             substring( _Tor.DataOF, 7, 2 )))  as abap.dats(8) ) as CreationDate, 
             
      _Tor.Motorista,
      _Exped.CreationDateRemessa,
      //     _Exped.DeliveryDocument,
      //      SubsequentDocument             ,
      _Exped.ShippingConditionName,
      _Exped.ShippingCondition



}
