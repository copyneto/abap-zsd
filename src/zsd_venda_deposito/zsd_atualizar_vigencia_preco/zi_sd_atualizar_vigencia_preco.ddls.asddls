@AbapCatalog.sqlViewName: 'ZV_SD_ATUAL_VIG'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Atualizar Vigência'
@Metadata.ignorePropagatedAnnotations: true

define view zi_sd_atualizar_vigencia_preco
  as select from a817

{
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

  key vtweg as vtweg,
  key ''    as pltyp,
  key werks as werks,
  key matnr as matnr,
      datab as datab,
      datbi as datbi,
      knumh as knumh
}
