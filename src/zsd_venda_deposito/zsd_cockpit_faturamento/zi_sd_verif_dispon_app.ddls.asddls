@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Verifica Disponibilidade'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #C,
  sizeCategory: #L,
  dataClass: #MIXED
}
define view entity ZI_SD_VERIF_DISPON_APP
  as select from    zi_sd_nsdm_mard     as _nsdm_mard

    left outer join ZI_SD_CENTRO_FAT_DF as _Centro_Fat_DF   on _Centro_Fat_DF.CentroFaturamento = _nsdm_mard.werks

    left outer join zi_sd_nsdm_mard     as _MaterialStockDf on  _MaterialStockDf.matnr = _nsdm_mard.matnr
                                                            and _MaterialStockDf.werks = _Centro_Fat_DF.CentroDepFechado
                                                            and _MaterialStockDf.lgort = _nsdm_mard.lgort

  association [0..1] to zi_verif_disp_estoque_qtdordem as _CheckStockOrdem   on  _CheckStockOrdem.Material        = $projection.Material
                                                                             and _CheckStockOrdem.Plant           = $projection.Plant
                                                                             and _CheckStockOrdem.StorageLocation = $projection.Deposito
  association [0..1] to zi_verif_disp_estoq_qtdremessa as _CheckStockRemessa on  _CheckStockRemessa.Material        = $projection.Material
                                                                             and _CheckStockRemessa.Plant           = $projection.Plant
                                                                             and _CheckStockRemessa.StorageLocation = $projection.Deposito

  //  association [0..1] to ZI_SD_VERIF_DISP_ESTOQUE as _CheckStock on  _CheckStock.Material        = $projection.Material
  //                                                                and _CheckStock.Plant           = $projection.Plant
  //                                                                and _CheckStock.StorageLocation = $projection.Deposito

{
  key _nsdm_mard.matnr              as Material,
  key _nsdm_mard.werks              as Plant,
  key _nsdm_mard.lgort              as Deposito,
      _Centro_Fat_DF.CentroDepFechado,
      cast( '' as meins )           as OrderQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      _nsdm_mard.labst              as QtdEstoqueLivre,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      _MaterialStockDf.labst        as QtdDepositoFechado,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      _CheckStockRemessa.QtdRemessa as QtdRemessa,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      _CheckStockOrdem.QtdOrdem     as QtdOrdem
}
