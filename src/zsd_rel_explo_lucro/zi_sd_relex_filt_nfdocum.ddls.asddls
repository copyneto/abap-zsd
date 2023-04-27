@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro N° Nota Fiscal'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_RELEX_FILT_NFDOCUM
  as select from I_BR_NFDocument
{
  key BR_NFNumber
}
where
     BR_NFNumber <> '000000'
  or BR_NFNumber is initial
group by
  BR_NFNumber
