@EndUserText.label: 'Projection SM30 Pallet'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_CKPT_AGEND_PALLET
  as projection on ZI_SD_CKPT_AGEND_PALLET
{
      //      @Consumption.filter.hidden: true
      //      @Consumption.hidden: true
  key Guid,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MATERIAL', element: 'Material'},
                                           additionalBinding: [{  element: 'Text', localElement: 'MaterialTexto' }]}]
      Material,
      MaterialTexto,
      Lastro,
      Altura,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_KUNNR', element: 'Kunnr'},
                                           additionalBinding: [{  element: 'KunnrName', localElement: 'ClienteTexto' }]}]
      Cliente,
      ClienteTexto,
      QtdTotal,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MEINS', element: 'UnidadeMed'}}]
      UnidadeDeMedidaPallet,
      CreatedBy,
      @Consumption.filter.selectionType: #INTERVAL
      CreatedAt,
      LastChangedBy,
      @Consumption.filter.selectionType: #INTERVAL
      LastChangedAt,
      @Consumption.filter.selectionType: #INTERVAL
      LocalLastChangedAt
}
