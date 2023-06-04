@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'valida Estorno'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COMODATO_LAST_EST 
as select from vbfa
{

  key vbelv,
  key vbeln as vbeln,
  max(posnn) as posnn,
     'X' as Estorno

}
where
vbtyp_n = 'N'
group by
  vbelv,
  vbeln
  
