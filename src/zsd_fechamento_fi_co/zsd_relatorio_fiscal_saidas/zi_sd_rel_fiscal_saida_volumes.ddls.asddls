@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Volumes de transporte'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZI_SD_REL_FISCAL_SAIDA_VOLUMES
  as select from j_1bnftransvol
{
  docnum,
  sum( pesol ) as PesoLiquidoVolumes,
  sum( pesob ) as PesoBrutoVolumes
}
group by
  docnum;
