@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca dos valores do CFOP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CFOP_ENTITY as select from ZI_SD_CFOP as J_1bagn
{
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CDS_CFOP' 
      @EndUserText.label: 'CFOP'
  key Cfop      as Cfop,
      @EndUserText.label: 'CFOP Interno' 
 //     @UI.hidden: true
      Cfop      as Cfop1,
      Text     as Text
}
