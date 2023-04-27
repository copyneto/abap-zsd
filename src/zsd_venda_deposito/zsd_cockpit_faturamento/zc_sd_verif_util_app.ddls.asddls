@EndUserText.label: 'App Verificar Utilização'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

@ObjectModel.semanticKey: ['SalesOrder']

define root view entity ZC_SD_VERIF_UTIL_APP
  as projection on ZI_SD_VERIF_UTIL_APP
  association to ZI_SD_VH_SUBST_MATERIAL as _SUBST_MATERIAL  on _SUBST_MATERIAL.Material = $projection.Material
                                                                                                                                                                                          
{
         @EndUserText.label: 'Ordem de cliente'
         @Consumption.semanticObject: 'SalesDocument'
         @ObjectModel.foreignKey.association: '_ZI_SalesDocumentQuickView'
  key    SalesOrder,
         @EndUserText.label: 'Item'
  key    SalesOrderItem,
         @ObjectModel.text.element: ['DescriptionMaterial']
         @EndUserText.label: 'Material'
         @Consumption.filter.mandatory: true
         @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MATERIAL', element: 'Material' } } ]
         Material,
         @EndUserText.label: 'Centro'
         @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PlantStdVH', element: 'Plant' } } ]
         @Consumption.filter.mandatory: true
         Plant,
         @EndUserText.label: 'Descrição do Material'
         DescriptionMaterial,
         @EndUserText.label: 'EAN'
         Ean,
         @ObjectModel.text.element: ['CustomerName']
         @EndUserText.label: 'Emissor da Ordem'
         @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_CUSTOMER', element: 'Customer' } } ]
         Customer,
         @EndUserText.label: 'Nome do Emissir da ordem'
         CustomerName,
         @EndUserText.label: 'Tipo de Ordem'
         @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_AUART', element: 'SalesDocumentType' } } ]
         SalesOrderType,
         @EndUserText.label: 'Qtde'
         OrderQuantity,
         @EndUserText.label: 'UMB'         
         @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MEINS', element: 'UnidadeMed' } } ]
         OrderQuantityUnit,
         @EndUserText.label: 'Data Faturamento'
         DataFat,
         @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VKORG', element: 'OrgVendas' } } ]
         SalesOrganization,
         @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VTWEG', element: 'CanalDistrib' } } ]
         DistributionChannel,
         @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PLTYP', element: 'PriceList' } } ]
         PriceListType,
         //         @EndUserText.label: 'Ordem'
         ////         @Consumption.filter : {  selectionType: #SINGLE, defaultValue: '0000001701' }
         //         @Consumption.filter : {  selectionType: #SINGLE, defaultValue: '0' }
         //         @ObjectModel.filter.transformedBy: 'ABAP:ZCLSD_VERIF_UTIL_FILTER'
         //         @ObjectModel.virtualElement: true
         //         //         @Consumption.filter.hidden: true
         //         Ordem,

         _SUBST_MATERIAL,
         _ZI_SalesDocumentQuickView
}
