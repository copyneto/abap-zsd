@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Último registro agendado'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_AGEN_DATA_LAST
  as select from ztsd_agendamento
{
  key ordem,
  key remessa,
      max( data_registro ) as Max_data_registro

}
group by
  ordem,
  remessa
