@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca dos valores do parvw'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_IONZ_PARVW
  as select from ztsd_ionz_parcei
{
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CONVESAO_PARVW'
//      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLBP_CONVERT_PARVW'
  key cast( partn_role as abap.char( 2 ) )  as PartnRole,
      @EndUserText.label: 'Função do parceiro Interno'
      partn_role as PartnRole1

}
