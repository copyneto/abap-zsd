@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Selec. dados Ordem-App Verif. Utilização'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_VERIF_UTIL_ORDEM
  as select from I_SalesOrderItem as _Item

{
  key  _Item.Material,
  key  _Item.Plant,
       _Item.OrderQuantityUnit,
       cast( '' as abap.char( 40 ) ) as Ordem,
       cast( '' as abap.numc( 6 )  ) as Item,
       @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
       cast( 0 as kwmeng  )          as QtdBase,
       cast( '' as abap.unit(3)   )  as UMBase

}
