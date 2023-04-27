@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca dados Materiais'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_VERIF_DISP_DADOS_MAT
  as select from    ZI_SD_VERIF_DISP_MATERIAL2 as _Mat
    inner join      mara                       as _MaterialData    on _MaterialData.matnr = _Mat.Material
    left outer join ZI_SD_CENTRO_FAT_DF        as _Centro_Fat_DF   on _Centro_Fat_DF.CentroFaturamento = _Mat.Plant
    left outer join nsdm_e_mard                as _MaterialStock   on  _MaterialStock.matnr = _Mat.Material
                                                                   and _MaterialStock.werks = _Mat.Plant
                                                                   and _MaterialStock.lgort = _Mat.Deposito
    left outer join nsdm_e_mard                as _MaterialStockDf on  _MaterialStockDf.matnr = _Mat.Material
                                                                   and _MaterialStockDf.werks = _Centro_Fat_DF.CentroDepFechado
                                                                   and _MaterialStockDf.lgort = _Mat.Deposito

    left outer join ZI_SD_VERIF_DISP_ESTOQUE   as _CheckStock      on  _CheckStock.Material        = _Mat.Material
                                                                   and _CheckStock.Plant           = _Mat.Plant
                                                                   and _CheckStock.StorageLocation = _Mat.Deposito
{
  key _Mat.Material,
  key _Mat.Plant,
  key _Mat.Deposito,
      _Mat.Descricao,
      _Mat.OrderQuantityUnit,

      cast( _Mat.data_solic_logist as timestamp )                                                                                      as data_solic_logist,

      case when _Mat.acaoLogistica = 'Sim'
      then cast ( 'X' as boole_d preserving type )
      else cast ( ' ' as boole_d preserving type )
      end                                                                                                                              as acaoLogistica,

      case
           when _Mat.acaoLogistica = 'Sim'
           then 3 --Verde
           else 1 --Vermelho
      end                                                                                                                              as ColorAcaoLogistica,


      _Mat.data_solic                                                                                                                  as dataSolic,
      _Mat.motivo_indisp                                                                                                               as motivoIndisp,
      _Mat.acaoNecessaria,

      _Centro_Fat_DF.CentroDepFechado,

      _MaterialData.meins                                                                                                              as MaterialUnit,
      case when _MaterialStock.matnr <> '' then 'X'
           else ''
           end                                                                                                                         as StockMardExist,
      case when _MaterialStockDf.matnr <> '' then 'X'
           else ''
           end                                                                                                                         as StockDfMardExist,

      @Semantics.quantity.unitOfMeasure: 'MaterialUnit'
      _MaterialStock.labst                                                                                                             as QtdEstoqueLivre,

      @Semantics.quantity.unitOfMeasure: 'MaterialUnit'
      _MaterialStockDf.labst                                                                                                           as QtdDepositoFechado,

      @Semantics.quantity.unitOfMeasure: 'MaterialUnit'
      _CheckStock.QtdOrdem,

      @Semantics.quantity.unitOfMeasure: 'MaterialUnit'
      _CheckStock.QtdRemessa,

      COALESCE(  cast(  _MaterialStock.labst  as abap.dec(13,3) ), 0 ) + COALESCE(cast( _MaterialStockDf.labst  as abap.dec(13,3) ), 0 ) -
      COALESCE(  cast( _CheckStock.QtdRemessa as abap.dec(15,3) ), 0 ) - COALESCE(cast( _CheckStock.QtdOrdem as abap.dec(15,3) ), 0 )  as Saldo,

      COALESCE(  cast(  _MaterialStock.labst  as abap.dec(13,3) ), 0 ) -
      COALESCE(  cast( _CheckStock.QtdRemessa as abap.dec(15,3) ), 0 ) - COALESCE(cast( _CheckStock.QtdOrdem as abap.dec(15,3) ), 0 )  as SaldoLivre,

      COALESCE(  cast( _MaterialStockDf.labst  as abap.dec(13,3) ), 0 ) - COALESCE(cast( _CheckStock.QtdOrdem as abap.dec(15,3) ), 0 ) as SaldoDf

}
