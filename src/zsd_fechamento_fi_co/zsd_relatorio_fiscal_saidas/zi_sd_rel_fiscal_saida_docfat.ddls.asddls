@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Doc Migo'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REL_FISCAL_SAIDA_DOCFAT
  as select from I_BR_NFItem
{
    BR_ReferenceNFNumber,
    BR_NFSourceDocumentItem,
    BR_NFSourceDocumentType,
    BR_NFSourceDocumentNumber as DocFaturamento,
    BR_NotaFiscal
    
    
} where BR_NFSourceDocumentType = 'BI'
