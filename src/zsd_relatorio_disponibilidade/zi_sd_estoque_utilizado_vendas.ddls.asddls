@AbapCatalog.sqlViewName: 'ZISDESTUTIL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Estoque utilizado nas vendas'
define view ZI_SD_ESTOQUE_UTILIZADO_VENDAS
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
