@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Campo Remessa para CDS Locais/Equipamento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_LOCAIS_EQUIP_REM
  as select from vbap
{
  key min(vbeln) as vbeln,
      vgbel,
      posnr,
      vbelv

}
group by
  vgbel,
  posnr,
  vbelv
