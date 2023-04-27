@AbapCatalog.sqlViewName: 'ZVSD_UNION_ITEM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'view - Item'
@Search.searchable: true
define view ZI_SD_04_UNION_ITEM
  as select from ztsd_intercompan     as Header
    inner join   ZI_SD_02_ITEM_SELECT as _Item on _Item.Guid = Header.guid

  association [0..1] to I_ProductUnitsOfMeasure as _MarmStock       on  _MarmStock.Product         = $projection.Material
                                                                    and _MarmStock.AlternativeUnit = $projection.StockUnit

  association [0..1] to I_ProductUnitsOfMeasure as _MarmAlternative on  _MarmAlternative.Product         = $projection.Material
                                                                    and _MarmAlternative.AlternativeUnit = $projection.AlternativeUnit
{
      @EndUserText.label      : 'Guid'
  key _Item.Guid,
      @EndUserText.label      : 'Material'
      @Search.defaultSearchElement : true
      @Search.fuzzinessThreshold : 0.8
      @Search.ranking : #HIGH
  key _Item.Material,
      @EndUserText.label      : 'Un.Med.'
  key _Item.MaterialBaseUnit,
      @EndUserText.label      : 'UM Estoque'
      _Item.StockUnit,
      @EndUserText.label      : 'UM Alter.'
      _Item.AlternativeUnit,
      @EndUserText.label      : 'Nome do Material'
      @Search.defaultSearchElement : true
      @Search.fuzzinessThreshold : 0.7
      _Item.MaterialName,
      @EndUserText.label      : 'Quantidade em Estoque'
      @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'
      cast( case when _Item.Fracionado = 'X' or _Item.AlternativeUnit is initial or _Item.AlternativeUnit is null
                 then _Item.StockQuantity
                 else cast( _Item.StockQuantity as abap.dec( 13, 3 ) ) *
                            DIVISION( (_MarmStock.QuantityNumerator   * _MarmAlternative.QuantityDenominator ),
                                      (_MarmStock.QuantityDenominator * _MarmAlternative.QuantityNumerator), 6)
      end as abap.quan(13,3))                          as MatlWrhsStkQtyInMatlBaseUnit,
      @EndUserText.label      : 'Quantidade Solicitada'
      _Item.QtdSol,
      case when _Item.QtdSol > 0 then 'X' else ' ' end as Selected
}
where
      Header.salesorder     is initial
  and Header.purchaseorder  is initial
  and Header.remessa_origem is initial

union select from ztsd_intercompan      as Header
  inner join      ztsd_intercompan      as _Original on _Original.remessa = Header.remessa_origem
  inner join      ZI_SD_02_ITEM_DISPLAY as _Item     on _Item.Guid = _Original.guid

association [0..1] to I_ProductUnitsOfMeasure as _MarmStock       on  _MarmStock.Product         = $projection.Material
                                                                  and _MarmStock.AlternativeUnit = $projection.StockUnit

association [0..1] to I_ProductUnitsOfMeasure as _MarmAlternative on  _MarmAlternative.Product         = $projection.Material
                                                                  and _MarmAlternative.AlternativeUnit = $projection.AlternativeUnit
{
      @EndUserText.label      : 'Guid'
  key Header.guid,
      @EndUserText.label      : 'Material'
      @Search.defaultSearchElement : true
      @Search.fuzzinessThreshold : 0.8
      @Search.ranking : #HIGH
  key _Item.Material,
      @EndUserText.label      : 'Un.Med.'
  key _Item.MaterialBaseUnit,
      @EndUserText.label      : 'UM Estoque'
      _Item.StockUnit,
      @EndUserText.label      : 'UM Alter.'
      _Item.AlternativeUnit,
      @EndUserText.label      : 'Nome do Material'
      @Search.defaultSearchElement : true
      @Search.fuzzinessThreshold : 0.7
      _Item.MaterialName,
      @EndUserText.label      : 'Quantidade em Estoque'
      @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'
      cast( case when _Item.Fracionado = 'X' or _Item.AlternativeUnit is initial or _Item.AlternativeUnit is null
                 then _Item.StockQuantity
                 else cast( _Item.StockQuantity as abap.dec( 13, 3 ) ) *
                            DIVISION( (_MarmStock.QuantityNumerator   * _MarmAlternative.QuantityDenominator ),
                                      (_MarmStock.QuantityDenominator * _MarmAlternative.QuantityNumerator), 6)
      end as abap.quan(13,3))                          as MatlWrhsStkQtyInMatlBaseUnit,
      @EndUserText.label      : 'Quantidade Solicitada'
      _Item.QtdSol,
      case when _Item.QtdSol > 0 then 'X' else ' ' end as Selected
}
where Header.salesorder     is initial
  and Header.purchaseorder  is initial
  and Header.remessa_origem is not initial


union select from ztsd_intercompan      as Header
  inner join      ZI_SD_02_ITEM_DISPLAY as _Item on _Item.Guid = Header.guid

association [0..1] to I_ProductUnitsOfMeasure as _MarmStock       on  _MarmStock.Product         = $projection.Material
                                                                  and _MarmStock.AlternativeUnit = $projection.StockUnit

association [0..1] to I_ProductUnitsOfMeasure as _MarmAlternative on  _MarmAlternative.Product         = $projection.Material
                                                                  and _MarmAlternative.AlternativeUnit = $projection.AlternativeUnit
{
      @EndUserText.label      : 'Guid'
  key _Item.Guid,
      @EndUserText.label      : 'Material'
      @Search.defaultSearchElement : true
      @Search.fuzzinessThreshold : 0.8
      @Search.ranking : #HIGH
  key _Item.Material,
      @EndUserText.label      : 'Un.Med.'
  key _Item.MaterialBaseUnit,
      @EndUserText.label      : 'UM Estoque'
      _Item.StockUnit,
      @EndUserText.label      : 'UM Alter.'
      _Item.AlternativeUnit,
      @EndUserText.label      : 'Nome do Material'
      @Search.defaultSearchElement : true
      @Search.fuzzinessThreshold : 0.7
      _Item.MaterialName,
      @EndUserText.label      : 'Quantidade em Estoque'
      @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'
      cast( case when _Item.Fracionado = 'X' or _Item.AlternativeUnit is initial or _Item.AlternativeUnit is null
                 then _Item.StockQuantity
                 else cast( _Item.StockQuantity as abap.dec( 13, 3 ) ) *
                            DIVISION( (_MarmStock.QuantityNumerator   * _MarmAlternative.QuantityDenominator ),
                                      (_MarmStock.QuantityDenominator * _MarmAlternative.QuantityNumerator), 6)
      end as abap.quan(13,3))                          as MatlWrhsStkQtyInMatlBaseUnit,
      @EndUserText.label      : 'Quantidade Solicitada'
      _Item.QtdSol,
      case when _Item.QtdSol > 0 then 'X' else ' ' end as Selected
}
where
     Header.salesorder    is not initial
  or Header.purchaseorder is not initial


