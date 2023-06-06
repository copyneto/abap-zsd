@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Valor Un prd conf NF'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REL_FISCAL_SAIDA_J1BLPP
  as select from j_1blpp as _J1BLPP
{
  key _J1BLPP.matnr,
  key _J1BLPP.bwkey,
  key _J1BLPP.bwtar,
      _J1BLPP.lppid,

      sum( cast(_J1BLPP.lppbrt as abap.fltp(16) ) + cast(_J1BLPP.subtval as abap.fltp(16) ) ) as VlTotalUnPrdConfS,
      sum( cast(_J1BLPP.lppbrt as abap.fltp(16) ) + cast(_J1BLPP.zipival as abap.fltp(16) ) ) as VlUnPrdConfI

}
where
  lppid = 'S'
group by
  _J1BLPP.matnr,
  _J1BLPP.bwkey,
  _J1BLPP.bwtar,
  _J1BLPP.lppid,
  _J1BLPP.lppbrt,
  _J1BLPP.subtval
