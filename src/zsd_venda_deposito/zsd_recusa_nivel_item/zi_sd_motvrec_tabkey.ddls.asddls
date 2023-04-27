@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Chave de Motivo de recusa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_MOTVREC_TABKEY
  as select from ZC_SD_RECUSA_NIVEL_ITEM
{
  key SalesOrder,
  key SalesOrderItem,
      concat( $session.client, concat( SalesOrder, SalesOrderItem ) ) as Tabkey
}
