@EndUserText.label: 'Tabela cadastro das regras por material'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

@ObjectModel.semanticKey: [ 'Centro', 'Uf', 'Material' ]
define root view entity ZC_SD_MATERIAL
  as projection on ZI_SD_MATERIAL
{
      @Consumption.valueHelpDefinition: [{entity: {name: 'C_Plantvaluehelp', element: 'Plant' }}]
  key Centro,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_REGION', element: 'Region' }}]
  key Uf,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_PRODUCT', element: 'Material' }}]
  key Material,
      Descricao,
      Agregado,
      IcmsDest,
      IcmsOrig,
      CompraInterna,
      BaseRedOrig,
      BaseRedDest,
      TaxaFcp,
      IcmsEfet,
      Baseredefet,
      PrecoCompar,
      PrecoPauta,
      AgregadoPauta,
      NroUnids,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_UNITS', element: 'Unit' }}]
      Um,
      @Consumption.valueHelpDefinition: [ {
            entity: {
              name: 'ZI_SD_DOMAIN',
              element: 'DomvalueL'
            }
          } ]
      Modalidade,
      CalcEfetivo,
      PercentualBcIcms,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
