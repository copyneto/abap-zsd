@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Verificação de Disponibilidade'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_VERIF_DISP_APP
  as select from mara                       as _mara
  //    inner join      ZI_SD_VERIF_DISP_MATERIAL2 as _Mat             on _Mat.Material = _mara.matnr
  //    left outer join ZI_SD_CENTRO_FAT_DF        as _Centro_Fat_DF   on _Centro_Fat_DF.CentroFaturamento = _Mat.Plant
  //    left outer join nsdm_e_mard                as _MaterialStock   on  _MaterialStock.matnr = _Mat.Material
  //                                                                   and _MaterialStock.werks = _Mat.Plant
  //                                                                   and _MaterialStock.lgort = _Mat.Deposito
  //    left outer join nsdm_e_mard                as _MaterialStockDf on  _MaterialStockDf.matnr = _Mat.Material
  //                                                                   and _MaterialStockDf.werks = _Centro_Fat_DF.CentroDepFechado
  //                                                                   and _MaterialStockDf.lgort = _Mat.Deposito
  //
  //    left outer join ZI_SD_VERIF_DISP_ESTOQUE   as _CheckStock      on  _CheckStock.Material        = _Mat.Material
  //                                                                   and _CheckStock.Plant           = _Mat.Plant
  //                                                                   and _CheckStock.StorageLocation = _Mat.Deposito
    inner join   ZI_SD_VERIF_DISP_DADOS_MAT as _Mat on _Mat.Material = _mara.matnr
  association to ZI_SD_VH_MOTIVO as _motivo on _motivo.Movito = $projection.motivoIndisp
  association to ZI_SD_VH_ACAO   as _acao   on _acao.Acao = $projection.acaoNecessaria
{

  key _Mat.Material,
  key _Mat.Plant,
  key _Mat.Deposito,
      _Mat.Descricao,
      //      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CHECK_QTY'
      //      _Mat.QtdOrdem,
      //      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CHECK_QTY'
      //      _Mat.QtdRemessa,
      //      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CHECK_QTY'
      //      _Mat.QtdEstoqueLivre,
      //      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CKPT_FAT_DEP_FEC'
      //      _Mat.Saldo,
      //      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CKPT_FAT_DEP_FEC'
      //      _Mat.QtdDepositoFechado,
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CKPT_FAT_DEP_FEC'
      //      _Mat.Status,
      //      @ObjectModel.virtualElement: true
      //      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CKPT_FAT_DEP_FEC'
      //      cast( 0 as abap.int1 )                     as ColorStatus,


      _Mat.OrderQuantityUnit,

      cast( _Mat.data_solic_logist as timestamp ) as data_solic_logist,
      _Mat.acaoLogistica,

      _Mat.ColorAcaoLogistica,

      _Mat.dataSolic,
      _Mat.motivoIndisp,
      _Mat.acaoNecessaria,
      _motivo.MotivoText,
      _acao.AcaoText,
      _Mat.CentroDepFechado,

      _Mat.MaterialUnit,
      _Mat.StockMardExist,
      _Mat.StockDfMardExist,

      @Semantics.quantity.unitOfMeasure: 'MaterialUnit'
      _Mat.QtdEstoqueLivre,

      @Semantics.quantity.unitOfMeasure: 'MaterialUnit'
      _Mat.QtdDepositoFechado,

      @Semantics.quantity.unitOfMeasure: 'MaterialUnit'
      _Mat.QtdOrdem,

      @Semantics.quantity.unitOfMeasure: 'MaterialUnit'
      _Mat.QtdRemessa,

      @Semantics.quantity.unitOfMeasure: 'MaterialUnit'
      cast( _Mat.Saldo as abap.quan(15,3) )       as Saldo,

      case
      when _Mat.Saldo > 0
      then cast( '0' as ze_status_estoque ) //Disponível
      else cast( '1' as ze_status_estoque )  //Indisponível
      end                                         as Status,

      case
      when _Mat.Saldo > 0 
      then 'Disponível'
      else 'Indisponível'
      end                                         as StatusDesc,

      case
      when _Mat.Saldo > 0
      then 3
      else 1
      end                                         as ColorStatus

}
//group by
//  _Mat.Material,
//  _Mat.Plant,
//  _Mat.Deposito,
//  _Mat.Descricao,
//  _Mat.OrderQuantityUnit,
//  _Mat.QtdOrdem,
//  _Mat.QtdRemessa,
//  _Mat.QtdEstoqueLivre,
//  _Mat.Saldo,
//  _Mat.QtdDepositoFechado,
//  _Mat.acaoLogistica,
//  _Mat.data_solic,
//  _Mat.data_solic_logist,
//  _Mat.acaoNecessaria,
//  _Mat.motivo_indisp,
//  _Mat.CalcDisponibilidade,
//  _Mat.Status,
//  _motivo.MotivoText,
//  _acao.AcaoText,
//  _Centro_Fat_DF.CentroDepFechado,
//  _mara.meins,
//  _MaterialStock.labst,
//  _MaterialStockDf.labst,
//  _CheckStock.QtdOrdem,
//  _CheckStock.QtdRemessa
