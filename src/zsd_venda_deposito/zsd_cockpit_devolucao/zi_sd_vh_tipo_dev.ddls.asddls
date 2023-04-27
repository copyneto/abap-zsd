@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Help search Tipo de devolução'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_VH_TIPO_DEV as select from dd07t as Domain
{
      @ObjectModel.text.element: [ 'StatusText' ]
  key domvalue_l as TipoDev,
      @UI.hidden: true
      ddlanguage as Language,
      ddtext     as StatusText
}
where
      Domain.domname  = 'ZD_TIPO_DEVOLUCAO'
  and Domain.as4local = 'A';
