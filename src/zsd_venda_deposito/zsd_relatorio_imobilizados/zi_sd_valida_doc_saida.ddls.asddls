@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS validar doc de saida'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_VALIDA_DOC_SAIDA 
  as select from   I_BR_NFDocument           as _NfDoc      


    {
    
key BR_NotaFiscal,
    BR_NFReferenceDocument,
    case BR_NFReferenceDocument
    when ' '
    then 'SEM' 
    else 'COM' end as SemDocSaida
    }
