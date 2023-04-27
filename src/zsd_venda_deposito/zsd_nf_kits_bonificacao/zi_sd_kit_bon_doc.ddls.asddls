@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Nota Fiscal Documento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_KIT_BON_DOC as select from I_BR_NFItem {
    key BR_NFSourceDocumentNumber,
    key BR_NotaFiscal     
}
where 
    BR_NFSourceDocumentType   = 'BI'
group by
    BR_NFSourceDocumentNumber,
    BR_NotaFiscal
