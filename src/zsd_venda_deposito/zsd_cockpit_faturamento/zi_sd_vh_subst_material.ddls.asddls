@AbapCatalog.sqlViewName: 'ZIVHSDSUBSMAT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Help Search: Substituir material'
@Search.searchable: true
define view ZI_SD_VH_SUBST_MATERIAL
  as select from mara as _mara
    inner join   mean as _mean on  _mean.ean11 = _mara.ean11
                               and _mean.eantp = 'HE'
    inner join   makt as _Text on  _Text.matnr = _mara.matnr
                               and _Text.spras = $session.system_language                               
{
      @UI.hidden: true
  key _mara.matnr                as Material,
      _mara.matnr                as Material_VH,
      _Text.maktx                as Text_VH,
      _mean.ean11                as Ean1_VH,
      _mara.meins                as Unid,
      @UI.hidden: true
      _mean.ean11                as Ean
}


