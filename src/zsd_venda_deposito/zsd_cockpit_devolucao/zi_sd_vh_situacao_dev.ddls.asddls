@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help Situação Devolução'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
@UI.presentationVariant: [{ sortOrder: [{ by: 'Situacao', direction: #ASC }] }]
define view entity ZI_SD_VH_SITUACAO_DEV
  as select from dd07t as Domain
{
      @ObjectModel.text.element: [ 'StatusText' ]
  key domvalue_l as Situacao,
      @UI.hidden: true
      ddlanguage as Language,
      ddtext     as StatusText
}
where
      Domain.domname  = 'ZD_SITUACAO_DEV'
  and Domain.as4local = 'A'
