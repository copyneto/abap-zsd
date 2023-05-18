@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca de última data por evento UF'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_DT_EVT_PREST_CONTAS
  as select from I_TranspOrdExecution as Ev

  //*Recupera último evento*//
  association [1..1] to ZI_SD_ULT_EVT_PREST_CONTAS as _UltimoEvt on $projection.TransportationOrderUUID = _UltimoEvt.TransportationOrderUUID

{
  key Ev.TransportationOrderUUID,
      Ev.TranspOrdExecution,
      Ev.TranspOrdEvtActualDateTime,
      tstmp_to_dats( Ev.TranspOrdEvtActualDateTime,
                      abap_user_timezone(   $session.user,
                                            $session.client,'NULL' ) ,
                                            $session.client, 'NULL' ) as TranspOrdEvtActualDate

}
where
  (
        Ev.TransportationOrderUUID = _UltimoEvt.TransportationOrderUUID
    and Ev.TranspOrdExecution      = _UltimoEvt.TranspOrdExecution
  )

group by
  TransportationOrderUUID,
  TranspOrdExecution,
  TranspOrdEvtActualDateTime
