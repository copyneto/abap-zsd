@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consumo Ordens de Vendas por Excel'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@UI.presentationVariant: [{ sortOrder: [{ by: 'SalesDocument', direction: #DESC }] }]
define view entity ZI_SD_ORDEM_VENDAS_UPLD as select from I_SalesDocument as _SalesDocument 
association to parent ZI_SD_ORDEM_VENDAS_EXCEL as _SalesDocUpload on $projection.SalesDocument =  _SalesDocUpload.SalesDocument{
    key SalesDocument,
        SDDocumentCategory,
        SalesDocumentType ,
        SalesOrganization,
        DistributionChannel, 
        OrganizationDivision, 
        SDDocumentReason, 
        CreatedByUser,
        LastChangedByUser,
        CreationDate ,
        CreationTime ,
        LastChangeDate ,
        LastChangeDateTime,  
      
      _SalesDocUpload 
}
