@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS busca valor min de item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_AGEND_MIN_ITEM
  as select from ztsd_agendamento as _agend
{
  key _agend.ordem     as Ordem,
      _agend.remessa   as Remessa,
      _agend.nf_e      as Nfe,
      min(_agend.item) as Item

}

group by
  _agend.ordem,
  _agend.remessa,
  _agend.nf_e
