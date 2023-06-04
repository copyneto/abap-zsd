@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Preencher Ultimo Doc recebimento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COMODATO_LAST_BSIK
  as select from    ZI_SD_COMODATO_LAST_VBFA as Vbfa
    left outer join bseg                     as Bseg on Bseg.vbeln = Vbfa.vbeln
    left outer join vbrk                     as Vbrk on vbrk.vbeln = Bseg.vbeln
    left outer join bsik_view                as Bsik on Bsik.xblnr = vbrk.xblnr
{
  key Vbfa.vbelv,
      Bseg.netdt,
      Bsik.belnr

}
where
  Bsik.belnr is not initial
