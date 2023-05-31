@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Lista de objeto para CDS Informações NF'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_INF_DISTRATO_CTR_OBJ
  as select from objk
{
  max(obknr) as obknr,
  datum,
  obzae,
  equnr,
  ihnum,
  bautl,
  iloan,
  sortf,
  bearb,
  objvw,
  sernr,
  matnr,
  eqsnr,
  taser,
  uii,
  eam_badi_flag,
  product

}
where
  taser = 'SER03'
group by
//  obknr,
  datum,
  obzae,
  equnr,
  ihnum,
  bautl,
  iloan,
  sortf,
  bearb,
  objvw,
  sernr,
  matnr,
  eqsnr,
  taser,
  uii,
  eam_badi_flag,
  product
