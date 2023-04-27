@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca dos valores do TAXSIT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_TAXSIT_ENTITY as select from ZI_SD_TAXSIT as J_1BTAXSIT
{
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CDS_TAXSIT' 
      @EndUserText.label: 'Situação tributária'
  key taxsit     as Taxsit,
      @EndUserText.label: 'Situação tributária Interno' 
//      @UI.hidden: true
      taxsit     as Taxsit1,
      Text     as Text
}
