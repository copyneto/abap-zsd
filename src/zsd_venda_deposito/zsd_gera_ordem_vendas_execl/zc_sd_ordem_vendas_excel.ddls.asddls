@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consumo Ordens de Vendas por Excel'
@Metadata.allowExtensions: true

define view entity ZC_SD_ORDEM_VENDAS_EXCEL
  as select from I_SalesDocument as _SalesDocument
//    composition [0..*] of ZC_SD_ORDEM_VENDAS_UPLD as _SalesDocUpload 
//association to parent ZC_SD_ORDEM_VENDAS_UPLD as  _SalesDocUpload on $projection.SalesDocument =  _SalesDocUpload.SalesDocument
{  key SalesDocument,
      SDDocumentCategory,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_ORDERTYPE', element: 'Auart' }}]   
      SalesDocumentType ,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_SALESORG', element: 'SalesOrgID' }}] 
      SalesOrganization,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_DISTRIBUTIONCHANNEL', element: 'OrgUnidID' }}]       
      DistributionChannel, 
      OrganizationDivision, 
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_DocumentReason', element: 'SalesAreaId' }}] 
      SDDocumentReason, 
      CreatedByUser,
      LastChangedByUser,
      CreationDate ,
      CreationTime ,
      LastChangeDate ,
      LastChangeDateTime

//_SalesDocUpload 

}
//where
//CreationDate = $session.system_date
//CreationDate = '20210904'
