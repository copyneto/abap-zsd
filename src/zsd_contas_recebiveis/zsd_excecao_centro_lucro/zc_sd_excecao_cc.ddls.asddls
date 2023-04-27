@EndUserText.label: 'CDS de Projeção - Exceção Centro de Custo'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_EXCECAO_CC as projection on ZI_SD_EXCECAO_CC {
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } }]
    @EndUserText.label: 'Centro'
    key Centro,    
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_BZIRK', element: 'RegiaoVendas' } }]
    @EndUserText.label: 'Região de Vendas'
    key RegiaoVendas,
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_KOSTL', element: 'CentroCusto' } }]
    @EndUserText.label: 'Centro de Custo'
    CentroCusto,    
    @EndUserText.label: 'Descrição Centro'
    DescricaoCentro,
    @EndUserText.label: 'Descrição Região Vendas'
    DescricaoRegiaoVendas,
    @EndUserText.label: 'Descrição Centro Custo'
    DescricaoCentroCusto,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt
}
