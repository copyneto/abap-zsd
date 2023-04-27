@AbapCatalog.sqlViewName: 'ZVVALORLOC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Valor da locação'
define view ZI_SD_VALOR_LOCACAO
  as select distinct from prcd_elements
{

  key knumv,
      @Semantics.amount.currencyCode : 'waerk'
      sum(kbetr) as kbetr,
      waerk

}
where
  kschl = 'ZPR0'
group by
  knumv,
  waerk
