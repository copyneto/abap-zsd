@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Locais/Equipamentos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZC_SD_LOCAIS_EQUIP_APP as select from ZI_SD_LOCAIS_EQUIP_APP {
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_CONTRATO', element: 'SalesContract' } }]
    key Contrato,
    key ContratoItem,
    key Remessa,
    Serie,
    CodigoEquip,
    DescricaoEquip,
    @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PlantStdVH', element: 'Plant' } }]
    Centro,
    DescricaoCentro,
    @EndUserText.label: 'Cod.Cliente'
    Cliente,
    RazaoSocial
    
//    vbeln,
//    vgbel,
//    sdaufnr,
//    obknr,
//    ObknrObjk,
//    equnr,
//    EqunrEqbs,
//    kunnr
}
