@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Filtro Tipo de Documento de Vendas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_RELEX_FILT_TPDOCVNDS
  as select from vbak
{
  key vgbel      as Vgbel,
      max(auart) as Auart,
      vbeln      as Vbeln

}
group by
  vgbel,
  vbeln
