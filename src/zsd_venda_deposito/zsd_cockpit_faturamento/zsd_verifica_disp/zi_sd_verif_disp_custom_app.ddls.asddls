@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Custom Entity App Verifica Disponibilidade'
define root view entity ZI_SD_VERIF_DISP_CUSTOM_APP
  as select from    ZI_SD_VERIF_DISP_APP as _Availability
    inner join      mara                 as _MaterialData    on _MaterialData.matnr = _Availability.Material
    left outer join nsdm_e_mard          as _MaterialStock   on  _MaterialStock.matnr = _Availability.Material
                                                             and _MaterialStock.werks = _Availability.Plant
                                                             and _MaterialStock.lgort = _Availability.Deposito
    left outer join nsdm_e_mard          as _MaterialStockDf on  _MaterialStockDf.matnr = _Availability.Material
                                                             and _MaterialStockDf.werks = _Availability.CentroDepFechado
                                                             and _MaterialStockDf.lgort = _Availability.Deposito
{
  key _Availability.Material,
  key _Availability.Plant,
  key _Availability.Deposito,
      _Availability.Descricao,
      _Availability.OrderQuantityUnit,
      _Availability.data_solic_logist,
      _Availability.acaoLogistica,
      _Availability.ColorAcaoLogistica,
      _Availability.dataSolic,
      _Availability.motivoIndisp,
      _Availability.acaoNecessaria,
      _Availability.MotivoText,
      _Availability.AcaoText,
      _Availability.CentroDepFechado,
      _MaterialData.meins    as MaterialUnit,
      case when _MaterialStock.matnr <> '' then 'X'
           else ''
           end               as StockMardExist,
      case when _MaterialStockDf.matnr <> '' then 'X'
           else ''
           end               as StockDfMardExist,
      @Semantics.quantity.unitOfMeasure: 'MaterialUnit'
      _MaterialStock.labst   as QtdEstoqueLivre,
      @Semantics.quantity.unitOfMeasure: 'MaterialUnit'
      _MaterialStockDf.labst as QtdDepositoFechado
}
