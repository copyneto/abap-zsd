@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Materiais'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_02_ITEM
  as select from ZI_SD_04_UNION_ITEM as _UnionItem 
//  as select from ztsd_interc_item    as _DBItem
//    inner join   ZI_SD_04_UNION_ITEM as _UnionItem on  _UnionItem.Guid             = _DBItem.guid
//                                                   and _UnionItem.Material         = _DBItem.material
//                                                   and _UnionItem.MaterialBaseUnit = _DBItem.materialbaseunit
  association to parent zi_sd_01_cockpit as _cockpit on _cockpit.Guid = $projection.Guid
{
  key _UnionItem.Guid,
      @Search.defaultSearchElement : true
      @Search.fuzzinessThreshold : 0.8
      @Search.ranking : #HIGH
  key _UnionItem.Material,
  key _UnionItem.MaterialBaseUnit,
      @Semantics.text: true
      @Search.defaultSearchElement : true
      @Search.fuzzinessThreshold : 0.7
      _UnionItem.MaterialName,

      @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'
      _UnionItem.MatlWrhsStkQtyInMatlBaseUnit,

      @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'
      _UnionItem.QtdSol,

      _UnionItem.Selected,

      _cockpit
}
