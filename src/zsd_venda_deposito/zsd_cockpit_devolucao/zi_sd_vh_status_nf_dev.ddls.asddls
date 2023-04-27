@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Help search Status Nf'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_SD_VH_STATUS_NF_DEV
  as select from dd07t as Domain
{
      @ObjectModel.text.element: [ 'StatusnFText' ]
  key domvalue_l as StatusNf,
      @UI.hidden: true
      ddlanguage as Language,
      ddtext     as StatusNfText
}
where
      Domain.domname    =  'ZD_STATUS_NF_DEV'
  and Domain.as4local   =  'A'
  and Domain.domvalue_l <> '';
