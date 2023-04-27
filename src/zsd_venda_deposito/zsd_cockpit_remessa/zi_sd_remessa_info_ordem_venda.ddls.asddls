@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit gerenciamento de remessas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REMESSA_INFO_ORDEM_VENDA
  as select from ZI_SD_REMESSA_SOMA_ORDEM_VENDA
{
  key SalesDocument,
      ItemGrossWeightAvailable,
      ItemGrossWeightTotal,
    
      cast( case
      when ItemGrossWeightTotal <= 0
      then 0
      when ItemGrossWeightAvailable <= 0
      then 0
      else ( cast( ItemGrossWeightAvailable as abap.fltp(16,3) )
           / cast( ItemGrossWeightTotal as abap.fltp(16,3) )
           * 100.00 )
      end as abap.fltp(16,3) )                                          as ItemGrossWeightPerc

}
