@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consumo dados de upload ordem de vendas'
@Metadata.allowExtensions: true
@UI.presentationVariant: [{ sortOrder: [{ by: 'SalesDocument', direction: #DESC }] }]
define root view entity ZC_SD_ORDEM_VENDAS_UPLD
 as select from ZI_SD_ORDEM_VENDAS_UPLD as _SalesDocument
 association to ZI_SD_ORDEM_VENDAS_EXCEL as _SalesDocUpload on _SalesDocUpload.SalesDocument = ' '
{
  key   _SalesDocument.SalesDocument         as Document,
        _SalesDocument.SDDocumentCategory    as Category,
        _SalesDocument.SalesDocumentType     as Type,
        _SalesDocument.SalesOrganization     as Organization,
        _SalesDocument.DistributionChannel   as Channel,
        _SalesDocument.OrganizationDivision  as Division,
        _SalesDocument.SDDocumentReason      as Reason,
        _SalesDocument.CreatedByUser         as CreatedByUser,
        _SalesDocument.LastChangedByUser     as LastChangedByUser,
        _SalesDocument.CreationDate          as CreationDate,
        _SalesDocument.CreationTime          as CreationTime,
        _SalesDocument.LastChangeDate        as LastChangeDate,
        _SalesDocument.LastChangeDateTime    as LastChangeDateTime,
        _SalesDocUpload.SalesDocument        as SalesDocument,
        @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_ORDERTYPE', element: 'Auart' }}]
        _SalesDocUpload.SalesDocumentType    as SalesDocumentType,
        @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_SALESORG', element: 'SalesOrgID' }}] 
        _SalesDocUpload.SalesOrganization    as SalesOrganization,
        @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_DISTRIBUTIONCHANNEL', element: 'OrgUnidID' }}] 
        _SalesDocUpload.DistributionChannel  as DistributionChannel,

        _SalesDocUpload.SDDocumentReason     as SDDocumentReason,
        _SalesDocUpload
}
where
         _SalesDocument.CreationDate = $session.system_date

