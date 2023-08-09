@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Verifica Disponibilidade'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType:{
  serviceQuality: #C,
  sizeCategory: #L,
  dataClass: #MIXED
}
define view entity zi_sd_verif_disponibilidade
  as select from ZI_SD_VERIF_DISPON_APP
  association [0..1] to zi_sd_verif_dispon_log as _solicLog on  _solicLog.material = $projection.Material
                                                            and _solicLog.centro   = $projection.Plant
{
  key Material,
  key Plant,
  key Deposito,
      CentroDepFechado,

      _solicLog.motivo_indisp    as motivoIndisp,
      _solicLog.acao             as acaoNecessaria,
      OrderQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      QtdEstoqueLivre,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      QtdDepositoFechado,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      QtdRemessa,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      QtdOrdem,
      //      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'

      cast( 
      round( fltp_to_dec( 
      coalesce( cast ( QtdEstoqueLivre as abap.fltp ), 0 ) +
      coalesce( cast ( QtdDepositoFechado as abap.fltp ), 0 ) -
      coalesce( cast ( QtdRemessa as abap.fltp ), 0 ) -
      coalesce( cast ( QtdOrdem as abap.fltp ), 0 )
//      as abap.dec( 15,3 ) ), 3 )  as Saldo,
      as abap.dec( 15,4 ) ), 3 ) as abap.dec(15,3) ) as Saldo,

      _solicLog
}
