@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Help Search: Status Monitor Campanha'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_VH_STAUSMONPROMO
  as select from dd07t as Domain
{
      @ObjectModel.text.element: [ 'StatusText' ]
  key domvalue_l as StatusId,
      @UI.hidden: true
      ddlanguage as Language,
      ddtext     as StatusText
}
where
      Domain.domname  = 'ZD_STATUS_MONITOR_CAMPANHA'
  and Domain.as4local = 'A';
