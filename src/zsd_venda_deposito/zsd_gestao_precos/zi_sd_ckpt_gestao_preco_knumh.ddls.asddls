@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca o ultimo e Nº reg.condição gerado'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_CKPT_GESTAO_PRECO_KNUMH
  as select from konp as I_Condicao
{
  key max(knumh) as knumh
}
