@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Monitor E-Commerce - Campo Saída Entrega'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_MONITOR_SAIDA_ENTREGA
  as select from ZI_SD_MONITOR_REM
{

  key DocRelationshipUUID,
      PrecedingDocument,
      cast ( ActualDate as abap.char( 20 ) ) as ActualDate
}
