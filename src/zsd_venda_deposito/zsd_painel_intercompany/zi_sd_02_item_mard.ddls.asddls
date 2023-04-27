@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Estoque'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_02_ITEM_MARD
  as select from A_MatlStkInAcctMod as MARD
{
  key Material,
  key Plant,
  key StorageLocation,
      MaterialBaseUnit                  as MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'
      sum(MatlWrhsStkQtyInMatlBaseUnit) as MatlWrhsStkQtyInMatlBaseUnit
}
where 
InventoryStockType = '01'
group by
  Material,
  Plant,
  StorageLocation,
  MaterialBaseUnit





























//  //  with parameters
//  //    p_fracionada : char1
//  as select from    ztsd_intercompan        as a
//    inner join      mard                    as b           on  b.werks = a.plant
//                                                           and b.lgort = a.lgort_origem
//    inner join      mara                    as e           on e.matnr = b.matnr
//    left outer join I_MaterialText          as c           on  c.Material = b.matnr
//
//                                                           and c.Language = $session.system_language
//  //    inner join      I_MaterialPlant  as b on b.Plant = a.plant
//  //    inner join      I_Material       as C on C.Material = b.Material
//    left outer join ztsd_interc_item        as d           on  d.material      = b.matnr
//                                                           and d.salesorder    = a.salesorder
//                                                           and d.plant         = a.plant
//                                                           and d.br_notafiscal = a.br_notafiscal
//                                                           and d.guid          = a.guid
//    left outer join I_Product               as _Product    on _Product.Product = b.matnr
//
//    left outer join I_ProductUnitsOfMeasure as _ProductUOM on  _ProductUOM.Product                       = b.matnr
//                                                           and _ProductUOM.GlobalTradeItemNumberCategory = 'IC'
//
//  association to parent zi_sd_01_cockpit as _cockpit on  $projection.guid          = _cockpit.Guid
//                                                     and $projection.salesorder    = _cockpit.Salesorder
//                                                     and $projection.plant         = _cockpit.Plant
//                                                     and $projection.werksd        = _cockpit.Werksd
//                                                     and $projection.br_notafiscal = _cockpit.br_notafiscal
//
//{
//
//  key a.guid,
//  key a.salesorder,
//  key a.plant,
//      //  key a.werks  as WERKSD,
//  key _cockpit.Werksd,
//  key a.br_notafiscal,
//  key b.matnr           as Material,
//      @Semantics.text: true
//      c.MaterialName,
//      @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'
//      d.qtdsol          as QtdSol,
//      //      case $parameters.p_fracionada
//      //      when 'X'
//      //      then _Product.BaseUnit
//      //      else _ProductUOM.AlternativeUnit
//      //      end      as MaterialBaseUnit,
//      _Product.BaseUnit as MaterialBaseUnit,
//      //      e.meins  as MaterialBaseUnit,
//      @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'
//      b.labst           as MatlWrhsStkQtyInMatlBaseUnit,
//      _cockpit
//
//}
//where
//  b.labst > 0
