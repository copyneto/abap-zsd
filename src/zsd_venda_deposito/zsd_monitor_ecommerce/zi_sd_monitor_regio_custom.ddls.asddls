@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Monitor E-commerce Região do cliente'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_MONITOR_REGIO_CUSTOM
  as select from I_SDDocumentCompletePartners                                                                  as Partner
    inner join   ZI_SD_MONITOR_PARAM( p_modulo : 'SD', p_chave1 : 'ECOMMERCE', p_chave2 : 'PARTNER_FUNCTION' ) as _Param   on _Param.parametro = Partner.PartnerFunction
  //  association to I_Customer as _Customer
  //    on $projection.Customer = _Customer.Customer
  //    inner join      I_Customer                                                                                    as _Customer on Partner.Customer = _Customer.Customer
    inner join   I_Address                                                                                     as _Address on _Address.AddressID = Partner.AddressID
{

  key Partner.SDDocument,
////  key Partner.SDDocumentItem,
      Partner.Customer,
      //      _Customer.Region,
      _Address.Region,
      Partner.PartnerFunction
      //      /* Associations */
      //      _Customer
}

group by
  Partner.SDDocument,
  Partner.Customer,
  _Address.Region,
  Partner.PartnerFunction
