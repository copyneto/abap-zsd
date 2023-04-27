@AbapCatalog.sqlViewName: 'ZISD_REGION'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca dos valores de País e Estado'
@ObjectModel.resultSet.sizeCategory: #XS
define view zi_sd_region as select from t005s as Region 
    association to t005u as _Text on $projection.Country      = _Text.land1
                                 and $projection.Region       = _Text.bland
                                 and _Text.spras = $session.system_language
{

key land1    as Country,
key bland    as Region,
_Text.bezei  as Text
    
}
where
      land1  = 'BR';
