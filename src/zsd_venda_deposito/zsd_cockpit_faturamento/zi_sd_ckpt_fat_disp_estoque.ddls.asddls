@AbapCatalog.sqlViewName: 'ZISD_FAT_EST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cockpit Faturamento-Verifica Disponibilidade de Estoque'
define view ZI_SD_CKPT_FAT_DISP_ESTOQUE
  //  as select from ZI_SD_CKPT_FAT_APP         as _CockPit
  //    inner join   I_SalesDocumentItem        as _SalesOrderItem       on  _SalesOrderItem.SalesDocument     =  _CockPit.SalesOrder
  //                                                                     and _SalesOrderItem.SalesDocumentItem <> '000000'
  as select from    I_SalesDocumentItem      as _SalesOrderItem
  //    inner join   ZI_SD_VERIF_DISP_DADOS_MAT as _CheckAvailabilityApp on  _CheckAvailabilityApp.Material = _SalesOrderItem.Material
  //                                                                     and _CheckAvailabilityApp.Plant    = _SalesOrderItem.Plant
  //                                                                     and _CheckAvailabilityApp.Deposito = _SalesOrderItem.StorageLocation

    left outer join ZI_SD_CENTRO_FAT_DF      as _Centro_Fat_DF   on _Centro_Fat_DF.CentroFaturamento = _SalesOrderItem.Plant
    left outer join nsdm_e_mard              as _MaterialStock   on  _MaterialStock.matnr = _SalesOrderItem.Material
                                                                 and _MaterialStock.werks = _SalesOrderItem.Plant
                                                                 and _MaterialStock.lgort = _SalesOrderItem.StorageLocation
    left outer join nsdm_e_mard              as _MaterialStockDf on  _MaterialStockDf.matnr = _SalesOrderItem.Material
                                                                 and _MaterialStockDf.werks = _Centro_Fat_DF.CentroDepFechado
                                                                 and _MaterialStockDf.lgort = _SalesOrderItem.StorageLocation

    left outer join ZI_SD_VERIF_DISP_ESTOQUE as _CheckStock      on  _CheckStock.Material        = _SalesOrderItem.Material
                                                                 and _CheckStock.Plant           = _SalesOrderItem.Plant
                                                                 and _CheckStock.StorageLocation = _SalesOrderItem.StorageLocation

{
  key _SalesOrderItem.SalesDocument,
  key _SalesOrderItem.SalesDocumentItem,
  key _SalesOrderItem.Material,
      _SalesOrderItem.Plant,
      _Centro_Fat_DF.CentroDepFechado,
      _SalesOrderItem.StorageLocation,
      _SalesOrderItem.SDProcessStatus,
      case when _MaterialStock.matnr <> '' then 'X'
           else ''
           end                                                                                                                                  as StockMardExist,

      case when _MaterialStockDf.matnr <> '' then 'X'
           else ''
           end                                                                                                                                  as StockDfMardExist,

      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      _MaterialStock.labst                                                                                                                      as Stock,
      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      _MaterialStockDf.labst                                                                                                                    as StockDf,

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
