@AbapCatalog.sqlViewName: 'ZVSD_GP_PARAM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Condições cadastradas na Parametrização'
define view ZI_SD_GESTAO_PRECO_COND_PARAM
  as select from ztca_param_val
{
  key low    as ConditionType,
      'ZPR0' as PresentationType
}
where
      modulo = 'SD'
  and chave1 = 'GESTAO_PRECO'
  and chave2 = 'TP_COND_PRECO'
  and chave3 = 'KSCHL'
  and sign   = 'I'
  and opt    = 'EQ'
  and low    is not initial

union select from ztca_param_val
{
  key low    as ConditionType,
      'ZVMC' as PresentationType
}
where
      modulo = 'SD'
  and chave1 = 'GESTAO_PRECO'
  and chave2 = 'TP_COND_MINIMO'
  and chave3 = 'KSCHL'
  and sign   = 'I'
  and opt    = 'EQ'
  and low    is not initial

union select from ztca_param_val
{
  key low    as ConditionType,
      'ZALT' as PresentationType
}
where
      modulo = 'SD'
  and chave1 = 'GESTAO_PRECO'
  and chave2 = 'TP_COND_INVASAO'
  and chave3 = 'KSCHL'
  and sign   = 'I'
  and opt    = 'EQ'
  and low    is not initial

group by
  low
