@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'verif_disp_estoque_qtdordem'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #C,
  sizeCategory: #M,
  dataClass: #MIXED
}
define view entity zi_verif_disp_estoq_qtdremessa
  as select from vbbe
{
  key matnr        as Material,
  key werks        as Plant,
  key lgort        as StorageLocation,
      meins        as MaterialUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialUnit'
      sum( omeng ) as QtdRemessa
}
where
  vbtyp = 'J'
group by
  matnr,
  werks,
  lgort,
  meins
