@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SD delivery first item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #L,
  dataClass: #MIXED
}
define view entity zi_sd_delivery_first_item
  as select from zi_sd_delivery_first_itm_union as _DlvFirstUnion
{
  key SalesDocument,
  key DeliveryDocument,
      min( SalesDocumentFirstItem )    as SalesDocumentFirstItem,
      min( DeliveryDocumentFirstItem ) as DeliveryDocumentFirstItem

}
group by
  SalesDocument,
  DeliveryDocument
