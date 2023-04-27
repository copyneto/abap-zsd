@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interf. - Busca Vendedor'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_STATUS_VENDEDOR_EXT
  as select from vbpa as _DocSD

  association to lfa1 as _MestreFornec on _MestreFornec.lifnr = _DocSD.lifnr
{
  key vbeln,
      _DocSD.lifnr,
      _MestreFornec.name1 as VendedorExt
}
where
     parvw = 'ZE'
