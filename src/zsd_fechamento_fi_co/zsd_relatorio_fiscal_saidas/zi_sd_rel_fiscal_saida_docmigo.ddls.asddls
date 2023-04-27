@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Doc Migo'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REL_FISCAL_SAIDA_DOCMIGO
  as select from I_BR_NFItem
{
    key BR_ReferenceNFNumber,
    BR_NFSourceDocumentItem,
    BR_NFSourceDocumentType,
    substring(BR_NFSourceDocumentNumber, 1, 10 ) as DocMigo,
    substring(BR_NFSourceDocumentNumber, 11, 4 ) as AnoMigo
    
    
} where BR_NFSourceDocumentType = 'MD'
