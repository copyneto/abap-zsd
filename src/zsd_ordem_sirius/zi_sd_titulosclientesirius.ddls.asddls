@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Títulos de clientes'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_TitulosClienteSirius
  as select from bsid_view as Bsid
  association to I_Customer as _Customer
    on $projection.kunnr = _Customer.Customer
{
  key bukrs,
  key kunnr,
  key umsks,
  key umskz,
  key augdt,
  key augbl,
  key zuonr,
  key gjahr,
  key belnr,
  key buzei,

      budat,
      zlsch,
      @Semantics.amount.currencyCode: 'waers'
      wrbtr,
      waers,
      zfbdt,
      zbd1t,
      zbd2t,
      zbd3t,
      xblnr,
      bschl,
      rebzg,

      _Customer.Customer,
      /* Associations */
      _Customer,
      _Customer._CustomerSalesArea.SalesOrganization
}

where
  (
        saknr                            <> '1120101004'
    and saknr                            <> '1120101009'
  )
  and(
        bstat                            <> 'M'
    and bstat                            <> 'S'
    and bstat                            <> 'V'
    and bstat                            <> 'W'
    and bstat                            <> 'Z'
  )
  and   shkzg                            =  'S'
  and   _Customer.CustomerCorporateGroup =  'CLIENTE'
