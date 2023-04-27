@AbapCatalog.sqlViewName: 'ZVSD_TIPO_CTR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help para Tipo CTR'
@ObjectModel.resultSet.sizeCategory: #XS
@ObjectModel.dataCategory: #TEXT
define view ZI_SD_VH_TIPO_CTR as select from tvak as _Auart
    join         tvakt as _Desc on  _Desc.auart  = _Auart.auart
                                and _Desc.spras  = 'P'
{
      @UI.textArrangement: #TEXT_ONLY
      @ObjectModel.text.element: ['TipoDesc']
  key _Auart.auart as TipoId,
      @UI.hidden: true
      substring ( _Desc.bezei, 1, 60 )  as TipoDesc
}
where
      _Auart.auart = 'Z023'
   or _Auart.auart = 'Z024'
  
