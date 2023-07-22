@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data Agendamento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #L,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_AGEND_REMESSA_DT   
as select from           ztsd_agendamento           as _agend
{
key _agend.ordem,
key _agend.item,
   max(_agend.data_registro) as DataRegistro,
   max(_agend.hora_registro) as HoraRegistro
} group by
_agend.ordem,
_agend.item
