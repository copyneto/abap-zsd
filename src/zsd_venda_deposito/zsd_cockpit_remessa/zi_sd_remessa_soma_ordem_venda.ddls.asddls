@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit gerenciamento de remessas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REMESSA_SOMA_ORDEM_VENDA
  as select from I_SalesDocumentItem
{
  key SalesDocument,

      cast( sum( case when SalesDocumentRjcnReason is initial
           then cast( ItemGrossWeight as abap.dec(15,3) )
           else cast( 0 as abap.dec(15,3) )
           end ) as abap.dec(15,3) )                   as ItemGrossWeightAvailable,

      cast( sum( ItemGrossWeight ) as abap.dec(15,3) ) as ItemGrossWeightTotal
}
group by
  SalesDocument
