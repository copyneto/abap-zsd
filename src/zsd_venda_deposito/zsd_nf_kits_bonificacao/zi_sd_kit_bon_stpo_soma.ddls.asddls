@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Parâmetros STPO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_KIT_BON_STPO_SOMA
  as select from ZI_SD_KIT_BON_STPO_CALC1 as _ListaTec
{
  key _ListaTec.Stlnr,
  key _ListaTec.Idnrk,
  key sum( _ListaTec.Menge ) as Menge,
      _ListaTec.Meins
}
group by
  _ListaTec.Stlnr,
  _ListaTec.Idnrk,
  _ListaTec.Meins
