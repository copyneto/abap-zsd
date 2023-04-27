@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Emissor da Ordem'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_MONITOR_PARTNER
  as select from I_SDDocumentCompletePartners as SDPartner
  // association to kna1 as _Partner on _Partner.kunnr = $projection.Customer
    inner join   I_Customer                   as _Partner on _Partner.Customer = SDPartner.Customer

{
  key SDPartner.SDDocument,
      //SDPartner.SDDocumentItem,
      SDPartner.PartnerFunction,

      SDPartner.Customer,
      SDPartner.Supplier,
      SDPartner.Personnel,
      _Partner.CustomerName

}

where
  SDPartner.PartnerFunction = 'AG'

group by
  SDPartner.SDDocument,
  SDPartner.PartnerFunction,
  SDPartner.Customer,
  SDPartner.Supplier,
  SDPartner.Personnel,
  _Partner.CustomerName
