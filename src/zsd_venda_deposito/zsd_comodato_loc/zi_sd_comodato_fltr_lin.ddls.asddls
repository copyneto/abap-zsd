@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro de Docnum na J_1BNFLIN'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COMODATO_FLTR_LIN
  as select from j_1bnflin
{
  key docnum,
      min(itmnum)               as itmnum,
      substring(refkey, 1, 10)  as MBLNR,
      substring(refkey, 11, 14) as MJAHR,
      min(werks)                as Werks
}
group by
  docnum,
  refkey
