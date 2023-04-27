@AbapCatalog.sqlViewName: 'ZSDEANMATNR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'teste'

define view ZI_SD_EAN_MATERIAL as select distinct from mean as _mean
inner join  mara  as _mara  on _mara.ean11 = _mean.ean11
inner join  marc  as _marc  on _marc.matnr = _mean.matnr

{

key _mean.matnr,
    _mean.ean11,
    _marc.werks
    
}
group by _mean.matnr, _mean.ean11, _marc.werks
