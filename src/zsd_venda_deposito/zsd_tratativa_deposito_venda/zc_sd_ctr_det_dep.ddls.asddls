@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consumo Controle Determinação Deposito'
@Metadata.allowExtensions: true
define root view entity ZC_SD_CTR_DET_DEP
  as projection on ZI_SD_CTR_DET_DEP
{
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_ORDERTYPE', element: 'Auart' }}]
  key Auart,
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_EMISSOR_ORDEM', element: 'Kunnr' }}]
  key Kunnr,
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_DocumentReason', element: 'SalesAreaId' }}] 
  key Augru,
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_GRP_MERCADORIA', element: 'GrpMercadoria' }}]
  key Matkl,
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_TIPO_PEDIDO_CLIENTE', element: 'Bsark' }}] 
  key Bsark,
@Consumption.valueHelpDefinition: [{entity: {name: 'C_Plantvaluehelp', element: 'Plant' }}]
  key Werks,
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_DEPOSITO', element: 'Lgort' }}]
      Lgort,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
