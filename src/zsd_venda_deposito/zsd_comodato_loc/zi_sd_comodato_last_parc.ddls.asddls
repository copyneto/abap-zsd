@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Parcelamento Comodato/Locação'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COMODATO_LAST_PARC
  as select from fpla
{
  key max(fplnr) as Fplnr,
      vbeln
}
group by
  vbeln
