@AbapCatalog.sqlViewName: 'ZIPORT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Descricao porto embarque/destino'
@ObjectModel.dataCategory: #TEXT
define view ZI_SD_PORTO_TEXT_VH
  as select from t615t
{
      @Semantics.language: true
  key spras as Spras,
  key land1 as Land1,
  key zolla as Zolla,
      @Semantics.text: true
      bezei as Bezei
}
