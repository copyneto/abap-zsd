@AbapCatalog.sqlViewName: 'ZVSDIMOB'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca Imobilizado'
define view ZI_SD_RELAT_BUSCA_IMOB
  as select distinct from anla
{
  key invnr  as Inventario,
      min( anln1 ) as Imobilizado
} group by invnr
