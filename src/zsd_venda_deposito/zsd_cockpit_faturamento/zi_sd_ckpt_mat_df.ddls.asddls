@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Estoque Material Fechado'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_MAT_DF
  as select from zi_sd_nsdm_mard as _MaterialStockDf
  association [0..1] to ZI_SD_CENTRO_FAT_DF as _Centro_Fat_DF on _Centro_Fat_DF.CentroDepFechado = _MaterialStockDf.werks
{
  key _MaterialStockDf.matnr,
  key _Centro_Fat_DF.CentroFaturamento,
  key _MaterialStockDf.lgort,
      _Centro_Fat_DF.CentroDepFechado,
      //      cast( 'UN' as meins ) as Unidade,
      _MaterialStockDf.Unidade,
      @Semantics.quantity.unitOfMeasure : 'Unidade'
      _MaterialStockDf.labst

}
