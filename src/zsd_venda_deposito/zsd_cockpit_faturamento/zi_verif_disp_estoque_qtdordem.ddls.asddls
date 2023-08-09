@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'verif_disp_estoque_qtdordem'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #M,
  dataClass: #MIXED
}
define view entity zi_verif_disp_estoque_qtdordem
  as select from vbbe
{
  key matnr        as Material,
  key werks        as Plant,
  key lgort        as StorageLocation,
      meins        as MaterialUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialUnit'
      sum( omeng ) as QtdOrdem
}
where
  vbtyp = 'C'
group by
  matnr,
  werks,
  lgort,
  meins
