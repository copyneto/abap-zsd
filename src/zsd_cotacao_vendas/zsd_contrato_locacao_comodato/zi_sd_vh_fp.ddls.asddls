@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help - Função Parceiro'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_VH_FP
  as select from tpar as _Funcao
  association to tpart as _Text on  _Text.parvw = _Funcao.parvw
                                and _Text.spras = $session.system_language
{
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CONVERSION_PARVW'
  key _Funcao.parvw as PartnerFunction,
      //      @EndUserText.label: 'Função Parceiro Interno'
      //      _Funcao.parvw as PartnerFunction1,
      @EndUserText.label: 'Descrição'
      _Text.vtext   as Text

}
