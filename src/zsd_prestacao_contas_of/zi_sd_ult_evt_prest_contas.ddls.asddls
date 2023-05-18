@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Último evento - Prestação de contas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_ULT_EVT_PREST_CONTAS
  as select from I_TranspOrdExecution as Execucao

{
  key TransportationOrderUUID as TransportationOrderUUID,
      max(TranspOrdExecution) as TranspOrdExecution

}
where
  (
    TranspOrdEventCode = 'ENTREGUE'
  )
  or(
    TranspOrdEventCode = 'HASSIGNATURE'
  )
  or(
    TranspOrdEventCode = 'DEVOLVIDO'
  )
  or(
    TranspOrdEventCode = 'PENDENTE'
  )
  or(
    TranspOrdEventCode = 'SINISTRO'
  )
  or(
    TranspOrdEventCode = 'COLETADO'
  )
  or(
    TranspOrdEventCode = 'NÃO COLETADO'
  )

group by
  TransportationOrderUUID
