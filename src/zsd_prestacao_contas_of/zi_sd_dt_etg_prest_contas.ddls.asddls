@AbapCatalog.sqlViewName: 'ZI_SD_DTETG'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca de última data de entrg por evt UF'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view ZI_SD_DT_ETG_PREST_CONTAS
  as select from I_TranspOrdExecution as Ev
  
  //*Recupera último evento*//
  association [1..1] to ZI_SD_ULT_ETG_PREST_CONTAS as _UltimoEvt on $projection.TransportationOrderUUID = _UltimoEvt.TransportationOrderUUID

{
  key Ev.TransportationOrderEventUUID,
      Ev.TransportationOrderUUID,
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