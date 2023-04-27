@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Comodato e locação - Locais/equipamento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_LOC_EQUIP
  as select from ZI_SD_LOC_EQUIP_CTR as LocEquip
  //  association to parent ZI_SD_COCKPIT_APP as _Cockpit on $projection.Contrato = _Cockpit.SalesContract
{
  key Contrato,
  key ContratoItem,
      Remessa,
      RemessaItem,
      Produto,
      ProdutoTexto,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLCA_EXIT_CONV_GERNR'
      cast ( Serie as abap.char( 18 ) ) as Serie,
      cast ( Serie as abap.char( 18 ) ) as SerieCV,
      Centro,
      CentroTexto,
      Cliente,
      ClienteTexto

      /* associations */
      //      _Cockpit
}

group by
  Contrato,
  ContratoItem,
  Remessa,
  RemessaItem,
  Produto,
  ProdutoTexto,
  Centro,
  CentroTexto,
  Cliente,
  ClienteTexto,
  Serie
