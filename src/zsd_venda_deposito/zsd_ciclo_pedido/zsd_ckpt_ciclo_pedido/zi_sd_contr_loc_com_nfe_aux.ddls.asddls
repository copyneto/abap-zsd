@AbapCatalog.sqlViewName: 'ZVSDNFECONT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'auxiliar consulta de nota fiscal'
define view ZI_SD_CONTR_LOC_COM_NFE_AUX
  as select distinct from j_1bnflin as _lin
  association to I_BR_NFDocument as _doc on _doc.BR_NotaFiscal = _lin.docnum
{
  key _lin.docnum,
  key _lin.itmnum,
      _lin.refkey,
      //concat( _doc.BR_NFeNumber , concat( '-', _doc.BR_NFSeries )  ) as NotaFiscal,
      _doc.BR_NFeNumber as NotaFiscal,
      _doc.CreationDate

}
where
  _lin.itmnum = '000010'
