@AbapCatalog.sqlViewName: 'ZVSD_TIPO_MI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help para Tipo Operação Parâmetros'
@ObjectModel.resultSet.sizeCategory: #XS
@ObjectModel.dataCategory: #TEXT
define view ZI_SD_VH_TIPO_MICRO

  as select from tvakt          as _Tvakt
 
    join ztca_param_val as _Param on modulo = 'SD'
                                 and chave1 = 'COCKPIT_SD'
                                 and chave2 = 'TIPO_OPERACAO'
                                 and chave3 = 'MICRO'
                                 and sign   = 'I'
                                 and opt    = 'EQ'
                                 and low    = _Tvakt.auart
{   
  key _Tvakt.auart as Id,
      'Micro'      as TipoMicro

}
where spras = $session.system_language
