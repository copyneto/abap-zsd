@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit gerenciamento de remessas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #L,
    dataClass: #MIXED
}
define view entity ZI_SD_REMESSA_INFO_PARC_EXT 
  as select from I_SalesOrderPartner        as Partner

    inner join   ZI_SD_VH_REMESSA_PARVW_EXT as _Param on _Param.PartnerFunction = Partner.PartnerFunction

  association [0..1] to ZI_CA_VH_LIFNR as _Supplier on _Supplier.LifnrCode = $projection.Partner

{
  key Partner.SalesOrder,
  key Partner.PartnerFunction,
      Partner.Supplier        as Partner,
      _Supplier.LifnrCodeName as PartnerName

}
