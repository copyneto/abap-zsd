@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ultimo VBFA'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COMODATO_LAST_VBFA
  as select from vbfa
{

  key vbelv,
      //  key fplnr,
  key fpltr,
      max(vbeln) as vbeln

}
where
      fplnr   is not initial
  and vbtyp_n = 'M'
  and fktyp   = 'D'
group by
  vbelv,
  //  fplnr,
  fpltr
