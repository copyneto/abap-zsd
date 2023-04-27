@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Contrados disponíveis para Faturamento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_LAST_PRGFAT_FATURAMT
  as select from fplt
{
  key fplnr      as Fplnr,
  key max(fpltr) as Fpltr,
      afdat      as Afdat
}
where
  fksaf = 'A'
group by
  fplnr,
  afdat
