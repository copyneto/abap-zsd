@AbapCatalog.sqlViewAppendName: 'ZINFITEMCEXTEND'
@EndUserText.label: 'Extend para I_BR_NFITEM_C'
extend view I_BR_NFItem_C with ZI_BR_NFITEM_C_EXTEND
{
  // IPI Base
  cast(_IPIValues.BR_NFItemBaseAmount as logbr_nficmsbaseamount preserving type) as ZBR_IPIBaseAmount

}
