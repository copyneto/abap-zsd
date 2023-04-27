@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Transportadora'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_MONITOR_SUPPLIER
  as select from I_SDDocumentCompletePartners as SDPartner
  //    association to I_BusinessPartner as _SupplierDescr on  _SupplierDescr.BusinessPartner = $projection.Supplier
    inner join   I_Supplier                   as _Supplier
      on _Supplier.Supplier = SDPartner.Supplier

{
  key SDPartner.SDDocument,
      //      SDPartner.SDDocumentItem,
      SDPartner.PartnerFunction,

      SDPartner.Customer,
      SDPartner.Supplier,
      SDPartner.Personnel,
      _Supplier.OrganizationBPName1 as SupplierName

}
where
  SDPartner.PartnerFunction = 'SP'

group by
  SDPartner.SDDocument,
  SDPartner.PartnerFunction,
  SDPartner.Customer,
  SDPartner.Supplier,
  SDPartner.Personnel,
  _Supplier.OrganizationBPName1
