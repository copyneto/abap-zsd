@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Conta'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REL_FISCAL_SAIDA_CONTA
  as select from vbfa                   as _VBFA
    inner join   I_MaterialDocumentItem as _MaterialDocument on  _MaterialDocument.MaterialDocument     = _VBFA.vbeln
                                                             and _MaterialDocument.MaterialDocumentItem = substring(
      _VBFA.posnn, 3, 4
    )
  association [1..1] to skat as _GLAccountText on  _GLAccountText.saknr = _MaterialDocument.GLAccount
                                               and _GLAccountText.spras = $session.system_language
{
  key _VBFA.vbelv,
      //  key _VBFA.vbeln,
  key _VBFA.posnv,
  key _VBFA.vbtyp_n,
  key _MaterialDocument.MaterialDocumentYear,
      _MaterialDocument.Plant,
      _MaterialDocument.GLAccount,
      _GLAccountText.txt20 as GLAccountText
}
group by
  _VBFA.vbelv,
  _VBFA.posnv,
  _VBFA.vbtyp_n,
  _MaterialDocument.MaterialDocumentYear,
  _MaterialDocument.Plant,
  _MaterialDocument.GLAccount,
  _GLAccountText.txt20
