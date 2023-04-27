@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Contrados disponíveis para Faturamento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_LAST_CONTRATO_FATURAMT
  as select from vbkd
{
  key vbeln as Vbeln,
      posnr as Posnr,
      fplnr as Fplnr
}
