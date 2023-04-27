@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Tabela de parametros'


define root view entity ZC_SD_TABELA_PARAM
  as select from ztca_param_val as Z
{
  key low
}
where
      modulo = 'SD'
  and chave1 = 'CONDICAO_DESCONTO'
group by
  low
