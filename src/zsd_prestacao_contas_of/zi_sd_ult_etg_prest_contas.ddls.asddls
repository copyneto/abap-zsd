@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Últmo evt de entrega Prestação de contas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_ULT_ETG_PREST_CONTAS
  as select from I_TranspOrdExecution as Execucao

{
  key TransportationOrderUUID as TransportationOrderUUID,
      max(TranspOrdExecution) as TranspOrdExecution

}
where
  (
        TranspOrdEventCode = 'ENTREGA_PARCIAL'
  )
  or(
        TranspOrdEventCode = 'ENTREGA_TOTAL'
  )
group by
  TransportationOrderUUID
