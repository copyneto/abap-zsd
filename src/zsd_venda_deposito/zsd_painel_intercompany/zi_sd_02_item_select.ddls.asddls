@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Seleção de Materiais'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_SD_02_ITEM_SELECT
  as select from    ztsd_intercompan        as Intercompany

    inner join      ZI_SD_02_ITEM_MARD      as MARD        on  MARD.Plant           = Intercompany.werks_origem
                                                           and MARD.StorageLocation = Intercompany.lgort_origem

    left outer join I_ProductUnitsOfMeasure as _ProductUOM on  _ProductUOM.Product                       = MARD.Material
                                                           and _ProductUOM.GlobalTradeItemNumberCategory = 'IC'

  association [0..1] to I_MaterialText   as _Text on  _Text.Material = MARD.Material
                                                  and _Text.Language = $session.system_language

  association [0..1] to ztsd_interc_item as _Item on  _Item.guid     = Intercompany.guid
                                                  and _Item.material = MARD.Material

  //  association [0..1] to I_ProductUnitsOfMeasure as _ProductUOM on  _ProductUOM.Product                       = MARD.Material
  //                                                               and _ProductUOM.GlobalTradeItemNumberCategory = 'IC'

{
  key Intercompany.guid                                          as Guid,
      @Search.defaultSearchElement : true
      @Search.fuzzinessThreshold : 0.8
      @Search.ranking : #HIGH
  key MARD.Material                                              as Material,
  key cast( case when Intercompany.fracionado = 'X'
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

      Intercompany.fracionado                                    as Fracionado

//      _Text,
//      _Item
}
where MARD.MatlWrhsStkQtyInMatlBaseUnit > 0
