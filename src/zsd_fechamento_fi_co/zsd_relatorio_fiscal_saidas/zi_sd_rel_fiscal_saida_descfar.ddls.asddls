@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Doc Migo'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REL_FISCAL_SAIDA_DESCFAR
  as select from I_BR_NFItem
{  
    BR_ReferenceNFNumber,
    BR_NFSourceDocumentItem,
    MaterialGroup,
    BR_NFNetDiscountAmount
    
    
} 
where MaterialGroup = 'FAR'
