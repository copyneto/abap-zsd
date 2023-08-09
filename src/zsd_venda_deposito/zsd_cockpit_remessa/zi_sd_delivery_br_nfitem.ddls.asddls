@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SD delivery first item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #L,
  dataClass: #MIXED
}
define view entity zi_sd_delivery_BR_NFItem
  as select from zi_sd_delivery_billing as _SDDeliveryBilling
  association [0..1] to I_BR_NFItem as _NFItem on  _NFItem.BR_NFSourceDocumentType   = 'BI'
                                               and _NFItem.BR_NFSourceDocumentNumber = $projection.BillingDocument
                                               and _NFItem.BR_NFSourceDocumentItem   = $projection.BillingDocumentItem
{
  key SalesDocument,
  key DeliveryDocument,
      SalesDocumentFirstItem,
      DeliveryDocumentFirstItem,
      BillingDocument,
      BillingDocumentItem,
//      _NFItem.BR_NotaFiscal as BR_NotaFiscal,

      /* Associations */
      _Billing,
      _NFItem
}
