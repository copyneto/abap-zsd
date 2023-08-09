@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Maior data logistica'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity zi_sd_verif_disp_max_dat_logis
  as select from ZI_SD_TF_VERIF_DISP
{
  key material,
  key centro,
      max(data_solic_logist) as data_solic_logist,
      data_solic,
      motivo_indisp,
      acao,
      acaolog
}
group by
  material,
  centro,
  data_solic,
  motivo_indisp,
  acao,
  acaolog




//  as select from ztsd_solic_log
//{
//  key material,
//  key centro,
//      max(data_solic_logist) as data_solic_logist,
//      max(data_solic)        as data_solic,
//      max(motivo_indisp)     as motivo_indisp,
//      max(acao)              as acao,
//      max(acaolog)           as acaolog
//}
//group by
//  material,
//  centro
