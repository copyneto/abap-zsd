@AbapCatalog.sqlViewName: 'ZVSD_TIPO_OP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help para Tipo Operação'
@ObjectModel.resultSet.sizeCategory: #XS
@ObjectModel.dataCategory: #TEXT
define view ZI_SD_VH_TIPO_OP  
 
  as select from ZI_SD_VH_TIPO_PARAM as _Param
{
  @UI.textArrangement: #TEXT_ONLY
  //@ObjectModel.text.element: ['TipoDesc']
  key  _Param.PresentationType as TipoOperacao 
 
}


group by
 PresentationType 

