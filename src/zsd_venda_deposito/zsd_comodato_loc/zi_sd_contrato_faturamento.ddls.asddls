@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Contrados disponíveis para Faturamento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CONTRATO_FATURAMENTO
  as select from ZI_SD_LAST_CONTRATO_FATURAMT as Cont

    inner join   ZI_SD_LAST_PRGFAT_FATURAMT   as ProgFat on ProgFat.Fplnr = Cont.Fplnr
{
  key Cont.Vbeln      as Vbeln,
      max(Cont.Fplnr) as Fplnr,
      ProgFat.Afdat   as Afdat

}

group by
  Cont.Vbeln,
  ProgFat.Afdat
