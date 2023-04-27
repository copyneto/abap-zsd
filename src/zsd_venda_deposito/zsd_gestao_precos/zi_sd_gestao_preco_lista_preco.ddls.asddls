@AbapCatalog.sqlViewName: 'ZVSD_LISTAPRECO'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Gestão Preço - Lista de Preço'
@Metadata.ignorePropagatedAnnotations: true

define view ZI_SD_GESTAO_PRECO_LISTA_PRECO
  as select from a817

{
  key kappl as kappl,
  key kschl as kschl,
  key vtweg as vtweg,
  key pltyp as pltyp,
  key werks as werks,
  key matnr as matnr,
      datab as datab,
      datbi as datbi,
      knumh as knumh
}

union select from a816

{
  key kappl as kappl,
  key kschl as kschl,
  key vtweg as vtweg,
  key ''    as pltyp,
  key werks as werks,
  key matnr as matnr,
      datab as datab,
      datbi as datbi,
      knumh as knumh
}
