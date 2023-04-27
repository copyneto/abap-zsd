@AbapCatalog.sqlViewName: 'ZVSDOVFATURA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta fluxo de documentos'
define view ZI_SD_OV_FATURA
  as select distinct from vbfa as _Flow
    inner join            vbrk as _Fatura on _Fatura.vbeln = _Flow.vbeln
{
  _Flow.vbelv   as OrdemVenda,
  _Fatura.vbeln as Fatura,
  _Fatura.fksto as Estornado
}
where
      _Flow.vbtyp_v = 'C'
  and _Flow.vbtyp_n = 'M'
