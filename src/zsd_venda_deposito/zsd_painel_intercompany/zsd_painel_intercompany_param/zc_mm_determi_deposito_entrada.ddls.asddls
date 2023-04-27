@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Determinação Depósito de Entrada'
@Metadata.allowExtensions: true
define root view entity zc_mm_determi_deposito_entrada 
as projection on zi_mm_determi_deposito_entrada
{
@Consumption.valueHelpDefinition: [{ entity:{ name: 'Zi_ca_vh_werks', element : 'WerksCode' }}]
key Werks,
@Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_LGORT', element : 'StorageLocation' }}]
Lgort,
CreatedBy,
CreatedAt,
LastChangedBy,
LastChangedAt,
LocalLastChangedAt  
}
