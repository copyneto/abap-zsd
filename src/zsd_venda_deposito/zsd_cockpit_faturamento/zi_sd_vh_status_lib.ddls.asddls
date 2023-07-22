@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Status Liberação'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_SD_VH_STATUS_LIB
  as select from dd07t as Domain
{
      @ObjectModel.text.element: [ 'StatusText' ]
  key domvalue_l as StatusEstoque,
      @UI.hidden: true
      ddlanguage as Language,
      ddtext     as StatusText
}
where
      Domain.domname    =  'ZD_STATUS_LIB'
  and Domain.as4local   =  'A'
  and Domain.domvalue_l <> '';
