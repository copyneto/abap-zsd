@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS hora máx'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_AGEN_HORA 
  as select from ztsd_agendamento
{
  key ordem,
  key remessa,
  key data_registro,
  max( hora_registro ) as Max_hora_registro
  
}
group by
 ordem, remessa, data_registro
