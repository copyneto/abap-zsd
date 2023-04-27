@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help para Mov Poder de Terceiros'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_VH_TipoMovPoderTerc
  as select from F_Mmim_Gmtype_Vh2
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @EndUserText.label: 'Movement Type'
  key GoodsMovementType,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      GoodsMovementTypeName
}
where
     GoodsMovementType = '631'
  or GoodsMovementType = '632'
  or GoodsMovementType = '633'
  or GoodsMovementType = '634'
  or GoodsMovementType = 'Y81'
  or GoodsMovementType = 'Y82'
  or GoodsMovementType = 'Y83'
  or GoodsMovementType = 'Y84'
