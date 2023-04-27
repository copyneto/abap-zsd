@AbapCatalog.sqlViewName: 'ZI_UNITS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca dos valores de Unidade de medidas'
define view ZI_SD_UNITS as select from t006 as Units    
    association to t006a as _Text on $projection.Unit      = _Text.msehi
                                 and _Text.spras = $session.system_language 
{
 key msehi as Unit,
 _Text.msehl as Text
}
