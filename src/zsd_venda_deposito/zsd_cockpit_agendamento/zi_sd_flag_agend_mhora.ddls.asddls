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
  as select from ztsd_agendamento       as _HoraAgenda
  inner join ZI_SD_FLAG_AGEND_HORA_VALID as _HoraValida on _HoraValida.ordem    = _HoraAgenda.ordem
                                                       and _HoraValida.item     = _HoraAgenda.item
                                                       and _HoraValida.remessa  = _HoraAgenda.remessa
                                                       and _HoraValida.nf_e     = _HoraAgenda.nf_e 
{
  key _HoraAgenda.ordem,
  key _HoraAgenda.item,
  key _HoraAgenda.remessa,
  key _HoraAgenda.nf_e,
  key _HoraAgenda.data_registro,
      max( _HoraAgenda.hora_registro ) as Max_hora_registro

}
group by  
  _HoraAgenda.ordem,
  _HoraAgenda.item,
  _HoraAgenda.remessa,
  _HoraAgenda.nf_e,
  _HoraAgenda.data_registro
