@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca item min da fatura'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_AGEN_ITEMMIN 
  as select from ZI_SD_CICLO( p_tipo : 'M') 
 {
  key SalesOrder,
 min( Item ) as Item
 }
 group by SalesOrder
