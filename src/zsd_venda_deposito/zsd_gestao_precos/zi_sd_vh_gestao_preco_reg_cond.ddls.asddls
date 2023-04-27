@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help: Registro da condição'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_VH_GESTAO_PRECO_REG_COND
  as select from konp
{
  key knumh as ConditionRecord,
      3     as ConditionRecordCriticality
}
group by
  knumh
