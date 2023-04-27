@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Contrato Reinscidido'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COMODATO_REINSCID
  as select from    vbak

    left outer join vbap on  vbap.vbeln = vbak.vbeln
                         and vbap.abgru is initial


{
  vbak.vbeln as Contrato,

  case
    when vbap.vbeln is not initial
        then ''
        else 'X'
        end  as Reinscidido

}
group by
  vbak.vbeln,
  vbap.vbeln
