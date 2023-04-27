@AbapCatalog.sqlViewName: 'ZVSD_TIPO_PA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help para Tipo Operação Parâmetros'
@ObjectModel.resultSet.sizeCategory: #XS
@ObjectModel.dataCategory: #TEXT
define view ZI_SD_VH_TIPO_PARAM  

  as select from ztca_param_val
{
  key low    as ConditionType,
      'Micro' as PresentationType
}
where
      modulo = 'SD'
  and chave1 = 'COCKPIT_SD'
  and chave2 = 'TIPO_OPERACAO'
  and chave3 = 'MICRO'
  and sign   = 'I'
  and opt    = 'EQ'
  and low    is not initial

union select from ztca_param_val
{
  key low    as ConditionType,
      'Macro' as PresentationType
}
where
      modulo = 'SD'
  and chave1 = 'COCKPIT_SD'
  and chave2 = 'TIPO_OPERACAO'
  and chave3 = 'MACRO'
  and sign   = 'I'
  and opt    = 'EQ'
  and low    is not initial

group by
  low
  
