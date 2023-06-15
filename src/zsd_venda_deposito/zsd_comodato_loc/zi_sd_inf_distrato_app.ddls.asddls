@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Comodato e locação - Info. Distrato'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_INF_DISTRATO_APP
  as select from ZI_SD_INF_DISTRATO_CTR
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
      NFRetorno,
      OrdemFrete,
      Centro,
      Material
}
