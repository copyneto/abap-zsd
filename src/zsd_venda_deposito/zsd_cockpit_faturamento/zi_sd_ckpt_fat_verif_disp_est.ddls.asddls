@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Verifica Estoque'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #L,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_FAT_VERIF_DISP_EST
  as select from vbbe as _SalesQtyMaterial
{
  key _SalesQtyMaterial.matnr as Material,

  key _SalesQtyMaterial.werks as Plant,

  key _SalesQtyMaterial.lgort as StorageLocation,

      _SalesQtyMaterial.meins as MaterialUnit,

      @Semantics.quantity.unitOfMeasure: 'MaterialUnit'
      sum( case when _SalesQtyMaterial.vbtyp = 'C' then cast( _SalesQtyMaterial.omeng as abap.dec(15,3))
                else  0 end ) as QtdOrdem,

      @Semantics.quantity.unitOfMeasure: 'MaterialUnit'
      sum( case when _SalesQtyMaterial.vbtyp = 'J' then cast( _SalesQtyMaterial.omeng as abap.dec(15,3))
                else  0 end ) as QtdRemessa
}

group by
  _SalesQtyMaterial.matnr,
  _SalesQtyMaterial.werks,
  _SalesQtyMaterial.lgort,
  _SalesQtyMaterial.meins
