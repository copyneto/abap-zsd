@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ordem de frete'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_FRETE_CONVERSION
  as select from I_SalesOrder

{
  key SalesOrder,
      concat( '0000000000000000000000000' , SalesOrder ) as Salesorder_conv

}
