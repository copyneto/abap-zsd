@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interf. - Customer'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_STATUS_CUST
  as select from I_SDDocumentCompletePartners

  //    left outer join   I_CustSalesPartnerFunc       as _PartnerFunc on _PartnerFunc.Customer = I_SDDocumentCompletePartners.Customer
  //                                                              and _PartnerFunc.PartnerFunction = 'ZI'
  //                                                              or _PartnerFunc.PartnerFunction = 'ZE'

  association to kna1 as _Partner on _Partner.kunnr = $projection.Customer

  //  association to I_CustSalesPartnerFunc as _PartnerFunc on _PartnerFunc.Customer = $projection.Customer

  //  association to I_Customer             as _Customer    on _Customer.Customer = $projection.Customer

{
  key SDDocument,
  key SDDocumentItem,
      PartnerFunction,
      Customer,
      //      _PartnerFunc.Customer as CustomerFuncParc,
      _Partner.name1 as CustomerPartnerDescription,
      _Partner.regio,
      _Partner.ort01,
      _Partner.adrnr //Para CDS ZI_FI_STATUS_CUST_ADDR
      //      _Customer.Region,
      //      _Customer.CityName




}
where
      SDDocumentItem  = '000010'
//  and PartnerFunction = 'ZI'
//  or  PartnerFunction = 'ZE'
