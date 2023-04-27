@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Conta'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REL_FISCAL_SAIDA_CONTA_1
  as select from I_MaterialDocumentItem       as _MaterialDocument
  association [1..1] to skat as _GLAccountText on  _GLAccountText.saknr = _MaterialDocument.GLAccount
                                               and _GLAccountText.spras = $session.system_language
{
  key _MaterialDocument.MaterialDocument,
  key _MaterialDocument.MaterialDocumentItem,
  key _MaterialDocument.MaterialDocumentYear,
      _MaterialDocument.GLAccount,
      _GLAccountText.txt20 as GLAccountText

}
