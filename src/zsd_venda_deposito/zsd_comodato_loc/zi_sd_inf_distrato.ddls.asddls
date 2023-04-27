@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Comodato e locação - Info. Distrato'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_INF_DISTRATO
  as select from ZI_SD_INF_DISTRATO_CTR
  //  association to parent ZI_SD_COCKPIT_APP as _Cockpit on $projection.Contrato = _Cockpit.SalesContract
{
  key Contrato,
  key ContratoItem,
      Solicitacao,
      Ordem,
      Remessa,
      Fatura,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLCA_EXIT_CONV_GERNR'
      cast ( Serie as abap.char( 18 ) ) as Serie,
      cast ( Serie as abap.char( 18 ) ) as SerieCV,
      CodigoEquip,
      DescricaoEquip,
      NFeNumber,
      OrdemFrete,
      NFRetorno

      /* associations */
      //      _Cockpit
}
