@AbapCatalog.sqlViewName: 'ZIVERIFEST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Verifica Estoque'
define view ZI_SD_VERIF_DISP_ESTOQUE
  as select from vbbe as _SalesQtyMaterial
{
  key _SalesQtyMaterial.matnr as Material,

  key _SalesQtyMaterial.werks as Plant,

  key _SalesQtyMaterial.lgort as StorageLocation,

      _SalesQtyMaterial.meins as MaterialUnit,

      @Semantics.quantity.unitOfMeasure: 'MaterialUnit'
      sum( case when _SalesQtyMaterial.vbtyp = 'C' then _SalesQtyMaterial.omeng
                else  0 end ) as QtdOrdem,

      @Semantics.quantity.unitOfMeasure: 'MaterialUnit'
      sum( case when _SalesQtyMaterial.vbtyp = 'J' then _SalesQtyMaterial.omeng
                else  0 end ) as QtdRemessa
}

group by
  _SalesQtyMaterial.matnr,
  _SalesQtyMaterial.werks,
  _SalesQtyMaterial.lgort,
  _SalesQtyMaterial.meins
