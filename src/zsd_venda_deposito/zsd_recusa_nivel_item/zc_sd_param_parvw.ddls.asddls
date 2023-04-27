@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Tabela de parametros'


define root view entity ZC_SD_PARAM_PARVW
  as select from ztca_param_val as Z
{
  key low
}
where
      modulo = 'SD'
  and chave1 = 'ALTERA_RECUSA'
  and chave2 = 'PARCEIRO_VENDEDOR'
group by
  low
