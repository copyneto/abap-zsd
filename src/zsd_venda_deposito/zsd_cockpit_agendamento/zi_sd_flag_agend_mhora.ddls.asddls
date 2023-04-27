@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Campo Agendamento Válido'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_FLAG_AGEND_MHORA
  as select from ztsd_agendamento
{
  key ordem,
  key item,
  key data_registro,
  max( hora_registro ) as Max_hora_registro
  
}
group by
 ordem, item, data_registro
