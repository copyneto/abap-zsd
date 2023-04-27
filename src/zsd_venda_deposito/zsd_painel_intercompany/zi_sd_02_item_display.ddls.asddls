@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Materiais'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define root view entity ZI_SD_02_ITEM_DISPLAY
  as select from    ztsd_intercompan        as Header
    inner join      ztsd_interc_item        as _Item       on _Item.guid = Header.guid

    left outer join ZI_SD_02_ITEM_MARD      as MARD        on  MARD.Plant           = Header.werks_origem
                                                           and MARD.StorageLocation = Header.lgort_origem
                                                           and MARD.Material        = _Item.material

    left outer join I_MaterialText          as _Text       on  _Text.Material = MARD.Material
                                                           and _Text.Language = $session.system_language

    left outer join I_ProductUnitsOfMeasure as _ProductUOM on  _ProductUOM.Product                       = MARD.Material
                                                           and _ProductUOM.GlobalTradeItemNumberCategory = 'IC'
{
  key Header.guid                                                as Guid,
      @Search.defaultSearchElement : true
      @Search.fuzzinessThreshold : 0.8
      @Search.ranking : #HIGH
  key _Item.material                                             as Material,
  key cast( case when Header.fracionado = 'X'
                   or _ProductUOM.AlternativeUnit is initial
                   or _ProductUOM.AlternativeUnit is null
                 then MARD.MaterialBaseUnit
                 else _ProductUOM.AlternativeUnit
      end as meins )                                             as MaterialBaseUnit,

      MARD.MaterialBaseUnit                                      as StockUnit,
      _ProductUOM.AlternativeUnit                                as AlternativeUnit,

      @Semantics.text: true
      @Search.defaultSearchElement : true
      @Search.fuzzinessThreshold : 0.7
      _Text.MaterialName                                         as MaterialName,

      @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'
      cast(MARD.MatlWrhsStkQtyInMatlBaseUnit as abap.quan(13,3)) as StockQuantity,

      @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'
      cast(_Item.qtdsol as abap.quan(13,3))                      as QtdSol,

      Header.fracionado                                          as Fracionado
}
where
     Header.salesorder    is not initial
  or Header.purchaseorder is not initial
