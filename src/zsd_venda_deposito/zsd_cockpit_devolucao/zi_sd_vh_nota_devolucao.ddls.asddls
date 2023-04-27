@AbapCatalog.sqlViewName: 'ZVSD_SHNOTADEV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Nota Devolução'
//@Search.searchable: true
define view ZI_SD_VH_NOTA_DEVOLUCAO

  as select from ZI_SD_CHAVE_ACESSO_NF_3C as _Nfe3C

{
      @UI.hidden: true
  key SearchHelp,
//      @Search.defaultSearchElement: true
      @EndUserText.label: 'Nf-e'
  key Nfe2    as Nfe,
      @UI.hidden: true
  key Centro2 as Centro,
//      @Search.defaultSearchElement: true
      @EndUserText.label: 'Série'
      Serie2  as Serie,
//      @Search.defaultSearchElement: true
      @EndUserText.label: 'Nº documento'
      Docnum

}
where
  _Nfe3C.Nfe2 is not initial
group by
  SearchHelp,
  Nfe2,
  Centro2,
  Serie2,
  Docnum

union select from ZI_SD_CHAVE_ACESSO_NF_CLIENTE as _Nfe3Cliente
{
      @UI.hidden: true
  key SearchHelp,
//      @Search.defaultSearchElement: true
      @EndUserText.label: 'Nf-e'
  key Nfe,
      @UI.hidden: true
  key Centro,
//      @Search.defaultSearchElement: true
      @EndUserText.label: 'Série'
      Serie,
//      @Search.defaultSearchElement: true
      @EndUserText.label: 'Nº documento'
      Docnum
}
where
      _Nfe3Cliente.Cancelada is null
  and _Nfe3Cliente.Nfe       is not initial
group by
  SearchHelp,
  Nfe,
  Centro,
  Serie,
  Docnum
