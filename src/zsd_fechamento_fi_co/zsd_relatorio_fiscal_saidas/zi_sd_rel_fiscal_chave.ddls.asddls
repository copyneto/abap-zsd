@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Concat chave de acesso'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REL_FISCAL_CHAVE
  as select from I_BR_NFeActive
{
  key BR_NotaFiscal,
      concat(Region,
      concat(BR_NFeIssueYear,
      concat(BR_NFeIssueMonth,
      concat(BR_NFeAccessKeyCNPJOrCPF,
      concat(BR_NFeModel,
      concat( BR_NFeSeries, concat( BR_NFeNumber,
      concat( BR_NFeRandomNumber , BR_NFeCheckDigit)))))))) as chaveAcesso
}
