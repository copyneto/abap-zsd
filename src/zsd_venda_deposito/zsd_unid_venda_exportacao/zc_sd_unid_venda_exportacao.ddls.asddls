@EndUserText.label: 'Unidade de venda para o exterior'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['ControlCode', 'ValidFrom']
define root view entity ZC_SD_UNID_VENDA_EXPORTACAO as projection on ZI_SD_UNID_VENDA_EXPORTACAO {
    @EndUserText.label : 'Cod Controle (NCM)'
    @ObjectModel.text.element: ['TextSteuc']
    @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_STEUC', element: 'Steuc' }}]    
    key ControlCode,
    key ValidFrom,
    _TextSteuc.text1 as TextSteuc,
    ValidTo,
@EndUserText.label : 'Unidade de Medida'
@ObjectModel.text.element: ['TextUnit']
@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_UNITS', element: 'Unit' }}]
    Unit,
    _Text.msehl as TextUnit,
@EndUserText.label : 'Unidade Medida Xml'
@ObjectModel.text.element: ['TextUnitXml']
//@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_UNITS', element: 'Unit' }}]
    UnitXml,
    _TextXml.msehl as TextUnitXml,    
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt
}
