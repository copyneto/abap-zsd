@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Campos de somatórios'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_SD_VERIF_DISP_FIELDS
  as select from I_SalesOrder as _SalesOrder
{

  key _SalesOrder.SalesOrder,

      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      cast( 0 as mng01 )      as QtdOrdem,

      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      cast( 0 as mng01  )     as QtdRemessa,

      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      cast( 0 as mng01  )     as QtdEstoqueLivre,

      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      cast( 0 as mng01  )     as Saldo,

      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      cast( 0 as mng01  )     as QtdDepositoFechado,

      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      cast( 0 as mng01  )     as CalcDisponibilidade,

      cast( ''  as vrkme ) as OrderQuantityUnit

}
