@AbapCatalog.sqlViewName: 'ZI_SD_PAR_DEV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Tipos Ordens Devolução'
define view ZI_SD_PARAM_TP_OV_DEV
  as select from ztca_param_val
{
  key modulo,
  key chave1,
  key chave2,
  key chave3,
  key cast( low  as abap.char(4) ) as TpFat,
  key cast( high as abap.char(4) ) as TpOrdem

}
where
      modulo = 'SD'
  and chave1 = 'ADM DEVOLUÇÃO'
  and chave2 = 'TP_OV_DEVOLUCAO'
  and chave3 = 'FKART'

union select from ztca_param_val
{
  key modulo,
  key chave1,
  key chave2,
  key chave3,
  key cast( low  as abap.char(4) ) as TpFat,
  key cast( high as abap.char(4) ) as TpOrdem

}
where
      modulo = 'SD'
  and chave1 = 'ADM DEVOLUÇÃO'
  and chave2 = 'TP_OV_RETORNO'
  and chave3 = 'FKART'
