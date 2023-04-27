@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Materiais'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_02_ITEM_COUNT
  as select from ztsd_intercompan as Intercompany
    inner join   ztsd_interc_item as _Item on _Item.guid = Intercompany.guid
{

  key _Item.guid,
      count( * ) as Quantity
}
group by
  _Item.guid
