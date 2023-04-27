@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Partners App ecommerce'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_PARTNER_DEV
  as select from I_SDDocumentCompletePartners
  association to kna1 as _Partner on _Partner.kunnr = $projection.Customer

{
  key SDDocument,
  key SDDocumentItem,
  key PartnerFunction,
      Customer,
      _Partner.name1

}
where
  PartnerFunction = 'AG'
