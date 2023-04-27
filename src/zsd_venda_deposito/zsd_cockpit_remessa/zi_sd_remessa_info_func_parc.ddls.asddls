@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit gerenciamento de remessas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REMESSA_INFO_FUNC_PARC
  as select from I_SalesOrderPartner    as Partner

    inner join   I_SalesOrder           as _Sales on _Sales.SalesOrder = Partner.SalesOrder

    inner join   ZI_SD_VH_REMESSA_PARVW as _Param on _Param.PartnerFunction = Partner.PartnerFunction

  association [0..1] to ZI_CA_VH_AUART as _SalesOrderType on _SalesOrderType.SalesDocumentType = $projection.SalesOrderType
  association [0..1] to ZI_CA_VH_KUNNR as _Customer       on _Customer.Kunnr = $projection.Customer
  association [0..1] to ZI_CA_VH_LIFNR as _Supplier       on _Supplier.LifnrCode = $projection.Supplier

{
  key Partner.SalesOrder,
  key Partner.PartnerFunction,
      Partner.Customer,
      _Customer.KunnrName                   as CustomerName,
      Partner.Supplier,
      _Supplier.LifnrCodeName               as SupplierName,
      Partner.Personnel,
      Partner.AddressID,
      Partner.ContactPerson,
      _Sales.SalesOrderType,
      _SalesOrderType.SalesDocumentTypeName as SalesOrderTypeName,

      /* associations */
      Partner._PartnerFunction
}

group by
  Partner.SalesOrder,
  Partner.PartnerFunction,
  Partner.Customer,
  _Customer.KunnrName,
  Partner.Supplier,
  _Supplier.LifnrCodeName,
  Partner.Personnel,
  Partner.AddressID,
  Partner.ContactPerson,
  _Sales.SalesOrderType,
  _SalesOrderType.SalesDocumentTypeName
