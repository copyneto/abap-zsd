@EndUserText.label: 'Cód Benefício e Valor ICMS Desonerado'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_CALCULO_DESONERADO 
as projection on ZI_SD_CALCULO_DESONERADO { 
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_ID_CBENEF', element: 'DomvalueL' }}]
    key Id,
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_REGION_FISCIAL', element: 'Txreg' }}]    
    key ShipFrom,
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_REGION_FISCIAL', element: 'Txreg' }}]        
    key ShipTo,    
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_AUART_ENTITY', element: 'Auart' }}]    
    key DocumentType,
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_MOTIVO_ORDEM_ENTITY', element: 'Augru' }}]      
    key OrderReason,
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_PRODUCT', element: 'Material' }}]     
    key MaterialNumber,
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_PRODUCT_GROUP', element: 'GrpMercadorias' }}]      
    key MaterialGroup,
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_tipo_movmento_entity', element: 'Bwart' }}]       
    key MovementType,
//    @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_DOMAIN_DIRECAO', element: 'DomvalueL' }}]     
//   key Direcao, 
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_CFOP_ENTITY', element: 'Cfop' }}]     
    key CfopExternal,
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_TAXSIT_ENTITY', element: 'Taxsit' }}]     
    key TaxSituation,
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_CBENEF_ENTITY', element: 'Cbenef' }}]     
    BenefitCode,
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_DOMAIN_MOTDESICMS', element: 'DomvalueL' }}]     
    ICMSExemption,
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_DOMAIN_TIPO_CALC', element: 'DomvalueL' }}]      
    TypeCalc,
//    StatisticalExemptionICMS,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt
}
