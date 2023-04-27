@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Coleta de Produtos Avariados'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity zc_sd_coleta_avarias 
   as select from zi_sd_coleta_avarias
{
  key SalesOrder,
      @ObjectModel.text.element: ['CustomerName']
      SoldToParty,
      CustomerName,
      remessa as OutboundDelivery,
      tor_id,
      CreationDate,
      SalesOrderDate,
      @EndUserText.label: 'Imprimir os documentos selecionados?'
      ImprimeForm,
      SalesOrganization,
      DistributionChannel
}
