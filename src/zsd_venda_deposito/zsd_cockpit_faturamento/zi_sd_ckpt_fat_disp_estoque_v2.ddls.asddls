@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Status disponibilidade estoque'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_FAT_DISP_ESTOQUE_V2
  as select from I_SalesDocumentItem as _SalesOrderItem

  association [0..1] to ZI_SD_CKPT_FAT_VERIF_DISP_EST as _CheckStock      on  _CheckStock.Material        = _SalesOrderItem.Material
                                                                          and _CheckStock.Plant           = _SalesOrderItem.Plant
                                                                          and _CheckStock.StorageLocation = _SalesOrderItem.StorageLocation

  association [0..1] to zi_sd_nsdm_mard               as _MaterialStock   on  _MaterialStock.matnr = _SalesOrderItem.Material
                                                                          and _MaterialStock.werks = _SalesOrderItem.Plant
                                                                          and _MaterialStock.lgort = _SalesOrderItem.StorageLocation

  association [0..1] to ZI_SD_CKPT_MAT_DF             as _MaterialStockDf on  _MaterialStockDf.matnr             = _SalesOrderItem.Material
                                                                          and _MaterialStockDf.CentroFaturamento = _SalesOrderItem.Plant
                                                                          and _MaterialStockDf.lgort             = _SalesOrderItem.StorageLocation
{
  key _SalesOrderItem.SalesDocument,
  key _SalesOrderItem.SalesDocumentItem,
  key _SalesOrderItem.Material,
      _SalesOrderItem.Plant,
      _MaterialStockDf.CentroDepFechado,
      _SalesOrderItem.StorageLocation,
      _SalesOrderItem.SDProcessStatus,

      _MaterialStock.matnr                                                                                                                      as MaterialCent,
      _MaterialStockDf.matnr                                                                                                                    as MaterialDF,

      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      _MaterialStock.labst                                                                                                                      as Stock,
      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      _MaterialStockDf.labst                                                                                                                    as StockDf,
      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      _SalesOrderItem.OrderQuantity,
      _SalesOrderItem.OrderQuantityUnit,

      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      _CheckStock.QtdOrdem,

      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      _CheckStock.QtdRemessa,

      COALESCE(  cast(  _MaterialStock.labst  as abap.dec(13,3) ), 0 ) + COALESCE(cast( _MaterialStockDf.labst  as abap.dec(13,3) ), 0 ) -
      COALESCE(  cast( _CheckStock.QtdRemessa as abap.dec(15,3) ), 0 ) - COALESCE(cast( _CheckStock.QtdOrdem as abap.dec(15,3) ), 0 )           as Saldo,

      COALESCE(  cast(  _MaterialStock.labst  as abap.dec(13,3) ), 0 ) -
      COALESCE(  cast( _CheckStock.QtdRemessa as abap.dec(15,3) ), 0 ) - COALESCE(cast( _CheckStock.QtdOrdem as abap.dec(15,3) ), 0 )           as SaldoLivre,

      COALESCE(  cast( _MaterialStockDf.labst  as abap.dec(13,3) ), 0 ) - COALESCE(cast( _SalesOrderItem.OrderQuantity as abap.dec(15,3) ), 0 ) as SaldoDf

}

where
  _SalesOrderItem.SalesDocumentRjcnReason is initial
