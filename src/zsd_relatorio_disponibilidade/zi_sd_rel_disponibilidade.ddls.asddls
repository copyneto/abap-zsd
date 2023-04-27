@AbapCatalog.sqlViewName: 'ZISDRELDISP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Relatório de disponibilidade'
@VDM.viewType: #COMPOSITE

define view ZI_SD_REL_DISPONIBILIDADE
  as select from    ZI_SD_VERIF_DISP_APP           as _Availability
    inner join      mara                           as _MaterialData     on _MaterialData.matnr = _Availability.Material
    left outer join nsdm_e_mard                    as _MaterialStock    on  _MaterialStock.matnr = _Availability.Material
                                                                        and _MaterialStock.werks = _Availability.Plant
                                                                        and _MaterialStock.lgort = _Availability.Deposito
    left outer join nsdm_e_mard                    as _MaterialStockDf  on  _MaterialStockDf.matnr = _Availability.Material
                                                                        and _MaterialStockDf.werks = _Availability.CentroDepFechado
                                                                        and _MaterialStockDf.lgort = _Availability.Deposito
    left outer join ZI_SD_ESTOQUE_UTILIZADO_VENDAS as _SalesQtyMaterial on  _SalesQtyMaterial.Material        = _Availability.Material
                                                                        and _SalesQtyMaterial.Plant           = _Availability.Plant
                                                                        and _SalesQtyMaterial.StorageLocation = _Availability.Deposito
{
  key _Availability.Material,

  key _Availability.Plant,

  key _Availability.Deposito,

      _Availability.Descricao,

      _Availability.CentroDepFechado,

      _MaterialData.meins as MaterialUnit,

      @Semantics.quantity.unitOfMeasure: 'MaterialUnit'
      case
        when _MaterialStock.labst is null then 0
        else _MaterialStock.labst
      end                 as QtdEstoqueLivre,

      @Semantics.quantity.unitOfMeasure: 'MaterialUnit'
      case
        when _MaterialStockDf.labst is null then 0
        else _MaterialStockDf.labst
      end                 as QtdDepositoFechado,

      @Semantics.quantity.unitOfMeasure: 'MaterialUnit'
      case
        when _SalesQtyMaterial.QtdOrdem is null then 0
        else _SalesQtyMaterial.QtdOrdem
      end                 as QtdOrdem,

      @Semantics.quantity.unitOfMeasure: 'MaterialUnit'
      case
        when _SalesQtyMaterial.QtdRemessa is null then 0
        else _SalesQtyMaterial.QtdRemessa
      end                 as QtdRemessa
}
