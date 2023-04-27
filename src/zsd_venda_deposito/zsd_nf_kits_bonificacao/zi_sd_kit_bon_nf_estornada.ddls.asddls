@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Nota Fiscal Estornada'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_KIT_BON_NF_ESTORNADA as select from I_BR_NFDocument {    
    key BR_NFReferenceDocument,
    key BR_NotaFiscal,
    key BR_NFeDocumentStatus      
}
where
    BR_NFType = 'IL'
group by
    BR_NFReferenceDocument,
    BR_NotaFiscal,
    BR_NFeDocumentStatus
