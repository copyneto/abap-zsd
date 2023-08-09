@AbapCatalog.sqlViewName: 'ZEIMPNFSCR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Impressão Nota Fiscal em Massa'
define view ZI_IMP_NOTAFISCAL_MASSA_SCR
  as select from ZI_IMP_NOTAFISCAL_MASSA
{
  key Docnum,
      Refkey,
      Werks,
      right( Tor_id, 10) as Tor_id,
      StopOrder,
      Fkart,
      Vbtyp,
      Belnr
}
group by
  Docnum,
  Refkey,
  Werks,
  Tor_id,
  StopOrder,
  Fkart,
  Vbtyp,
  Belnr
