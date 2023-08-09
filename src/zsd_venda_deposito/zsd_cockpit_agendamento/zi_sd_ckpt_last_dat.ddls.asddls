@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Último registro agendado'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_LAST_DAT
  as select from ztsd_agendamento          as Agend

    inner join   ZI_SD_CKPT_AGEN_DATA_LAST as _MaxData on  _MaxData.ordem             = Agend.ordem
                                                       and _MaxData.remessa           = Agend.remessa
                                                       and _MaxData.Max_data_registro = Agend.data_registro
    inner join   ZI_SD_CKPT_AGEN_HORA      as _MHORA   on  _MHORA.ordem             = Agend.ordem
                                                       and _MHORA.remessa           = Agend.remessa
                                                       and _MHORA.data_registro     = _MaxData.Max_data_registro
                                                       and _MHORA.Max_hora_registro = Agend.hora_registro
{
  key Agend.ordem,
  key Agend.remessa,
      max( Agend.data_registro ) as Max_data_registro,
      max( Agend.hora_registro ) as Max_hora_registro

}
group by
  Agend.ordem,
  Agend.remessa
