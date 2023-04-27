@AbapCatalog.sqlViewName: 'ZVSD_NFDOC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ordem de Venda para CDS Cockpit'
define view ZI_SD_COCKPIT_NFDoc
    as select from I_BR_NFItem as _NFItem
    inner join I_BR_NFDocument as _NFDoc on _NFDoc.BR_NotaFiscal = _NFItem.BR_NotaFiscal
    association [0..1] to vbfa as _Vbfa  on _Vbfa.vbeln          = _NFItem.BR_NFSourceDocumentNumber
                                        and _Vbfa.vbtyp_v        = 'M'
{
    key 
        _NFItem.BR_NFSourceDocumentNumber as SourceDoc,
        _NFItem.BR_NotaFiscal,
        _Vbfa.vbelv,
        _Vbfa.vbeln,
        _Vbfa 
}
where _NFDoc.BR_NFDirection = '1'
  and _NFDoc.BR_NFIsCanceled <> 'X'
  and _NFDoc.BR_NFDocumentType <> '5'
