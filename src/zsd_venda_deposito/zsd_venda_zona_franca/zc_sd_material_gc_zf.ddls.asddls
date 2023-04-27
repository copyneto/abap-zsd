@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Regras NFs vendas café grão crú Manaus'
@Metadata.allowExtensions: true
define root view entity ZC_SD_MATERIAL_GC_ZF as projection on ZI_SD_MATERIAL_GC_ZF {
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_MATERIAL', element: 'Material' }}]
    key Matnr,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt
}
