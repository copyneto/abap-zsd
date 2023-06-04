@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Status ativos doc entrada'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_STATUS_ATIVO_ENTRADA
  as select from           I_BR_NFItem               as _NfItemSaida
    inner join             I_BR_NFDocument           as _NfDocSaida   on _NfDocSaida.BR_NotaFiscal = _NfItemSaida.BR_NotaFiscal

  //    left outer join        I_BR_NFDocument           as _NfDocEntrada on _NfDocSaida.BR_NotaFiscal = lpad(cast(_NfDocEntrada.BR_NFReferenceDocument as abap.char(10)), 10, '0')
    left outer join        ZI_SD_STATUS_DOCUMENT     as _NfDocEntrada on  _NfDocSaida.BR_NotaFiscal       = lpad(
      cast(
        _NfDocEntrada.BR_NFReferenceDocument         as abap.char(
                  10
                )
      ), 10, '0'
    )
                                                                      and _NfDocEntrada.BR_NotaFiscalItem = _NfItemSaida.BR_NotaFiscalItem

  //    left outer join        I_BR_NFItem               as _NfItem2    on _NfItem2.BR_NotaFiscal = _NfDocEntrada.BR_NotaFiscal
  //                                                                    and _NfItem2.BR_NotaFiscalItem = _NfItemSaida.BR_NotaFiscalItem
    left outer to one join I_BillingDocument         as _BillingDoc   on _BillingDoc.BillingDocument = _NfItemSaida.BR_NFSourceDocumentNumber

    left outer join        t001w                     as _t001w        on _t001w.werks = _NfItemSaida.Plant

    left outer join        ZI_SD_ATIVOS_IMOBILIZADOS as _Ativos       on  _Ativos.Fkart         = _BillingDoc.BillingDocumentType
                                                                      and _Ativos.RegiaoSaida   = _t001w.regio
                                                                      and _Ativos.RegiaoDestino = _NfDocSaida.BR_NFPartnerRegionCode

    left outer join        ZI_SD_ATIVOS_IMOBILIZADOS as _Ativos3      on  _Ativos3.Fkart         = _BillingDoc.BillingDocumentType
                                                                      and _Ativos3.RegiaoSaida   = _t001w.regio
                                                                      and _Ativos3.RegiaoDestino = ' '


    left outer join        ZI_SD_ATIVOS_IMOBILIZADOS as _Ativos2      on  _Ativos2.Fkart       = _BillingDoc.BillingDocumentType
                                                                      and _Ativos2.RegiaoSaida = _NfDocSaida.BR_NFPartnerRegionCode


{


  key _NfItemSaida.BR_NotaFiscal,
  key _NfItemSaida.BR_NotaFiscalItem,


      case
      when cast( coalesce( _Ativos.Fkart,'' ) as abap.char(4) )  = ''
      then _Ativos3.DiasAtraso1
      else _Ativos.DiasAtraso1
      end                                                                            as DiasAtraso1,

      case
      when cast( coalesce( _Ativos.Fkart,'' ) as abap.char(4) )  = ''
      then _Ativos3.DiasAtraso2
      else _Ativos.DiasAtraso2
      end                                                                            as DiasAtraso2,



      //      _Ativos.DiasAtraso1,
      //      _Ativos.DiasAtraso2,
      case
      when cast( coalesce( _Ativos.RegiaoDestino,'N/A' ) as abap.char(3) )  = 'N/A'
      then _Ativos2.RegiaoSaida
      else _Ativos.RegiaoDestino
      end                                                                            as RegiaoDestino,
      cast( coalesce( _NfDocEntrada.BR_NotaFiscal, '0000000000' ) as abap.numc(10) ) as DocnumEntrada,
      _NfDocSaida.BR_NFReferenceDocument,
      _NfItemSaida.BR_NFSourceDocumentNumber,
      _BillingDoc.BillingDocumentType,
      _NfDocSaida.BR_NFPostingDate,
      case
       when cast( coalesce( _NfDocEntrada.BR_NotaFiscal, '' ) as abap.char(10) ) = ''  //Docnum Entrada
           then dats_days_between(_NfDocSaida.BR_NFPostingDate, $session.user_date )
           else 0
           end                                                                       as nodias



}
group by
  _NfItemSaida.BR_NotaFiscal,
  _NfItemSaida.BR_NotaFiscalItem,
  _Ativos.DiasAtraso1,
  _Ativos.DiasAtraso2,
  _Ativos.RegiaoDestino,
  _Ativos2.RegiaoSaida,
  _NfDocEntrada.BR_NotaFiscal,
  _NfDocSaida.BR_NFReferenceDocument,
  _NfItemSaida.BR_NFSourceDocumentNumber,
  _BillingDoc.BillingDocumentType,
  _NfDocSaida.BR_NFPostingDate,
  _NfDocEntrada.BR_NotaFiscal,
  _NfDocSaida.BR_NFPostingDate,
  _Ativos3.DiasAtraso1,
  _Ativos3.DiasAtraso2,
  _Ativos.Fkart
