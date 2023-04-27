@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Status dos Ativos Imobilizados'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_STATUS_ATIVOS
  as select from           I_BR_NFItem               as _NfItem
  //  as select from I_BR_NFDocument           as _NfDoc
  //  inner join    I_BR_NFItem            as _NfItem  on _NfDoc.BR_NotaFiscal = _NfItem.BR_NotaFiscal


    left outer join        I_BR_NFItem               as _NfItem2    on  _NfItem.BR_ReferenceNFNumber = _NfItem2.BR_NotaFiscal
                                                                    and _NfItem.BR_ReferenceNFItem   = _NfItem2.BR_NotaFiscalItem

    left outer join        I_BR_NFDocument           as _NfDoc      on _NfDoc.BR_NotaFiscal = _NfItem2.BR_NotaFiscal

    left outer to one join I_BillingDocument         as _BillingDoc on _BillingDoc.BillingDocument = _NfItem.BR_NFSourceDocumentNumber

  //    left outer join I_BR_NFItem         as _NFEntrada    on _NfItem.BR_NFSourceDocumentNumber = _NfItem.BR_NotaFiscal
  //
    left outer join        t001w                     as _t001w      on _t001w.werks = _NfItem.Plant
  //
    left outer join        ZI_SD_ATIVOS_IMOBILIZADOS as _Ativos     on _Ativos.Fkart = _BillingDoc.BillingDocumentType
  //  and _Ativos.RegiaoDestino = _t001w.regio
  //and _Ativos.RegiaoSaida   = _t001w.regio
{


  key _NfDoc.BR_NotaFiscal,
  key _NfItem2.BR_NotaFiscalItem,
      _Ativos.DiasAtraso1,
      _Ativos.DiasAtraso2,
      _Ativos.RegiaoSaida,
      cast( coalesce( _Ativos.RegiaoDestino,'N/A' ) as abap.char(3) ) as RegiaoDestino,
      _NfDoc.BR_NFPostingDate,
      case
      when _NfItem2.BR_NotaFiscal is null //Docnum saída
      then dats_days_between(_NfDoc.BR_NFPostingDate, $session.user_date )
      else 0
      end                                                             as nodias



}
