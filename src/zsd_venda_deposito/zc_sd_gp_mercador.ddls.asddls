@EndUserText.label: 'Tabela cadastro regras Grp Mercadorias'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

@ObjectModel.semanticKey: [ 'Centro', 'Uf', 'GrpMercadoria' ]

define root view entity ZC_SD_GP_MERCADOR
  as projection on ZI_SD_GP_MERCADOR
{
      @Consumption.valueHelpDefinition: [{entity: {name: 'C_Plantvaluehelp', element: 'Plant' }}]
  key Centro,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_REGION', element: 'Region' }}]
  key Uf,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_PRODUCT_GROUP', element: 'GrpMercadorias' }}]
  key GrpMercadoria,
      Descricao,
      Agregado,
      IcmsDest,
      IcmsOrig,
      CompraInterna,
      BaseRedOrig,
      BaseRedDest,
      TaxaFcp,
      IcmsEfet,
      BaseRedEfet,
      PrecoCompar,
      PrecoPauta,
      AgregadoPauta,
      NroUnids,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_UNITS', element: 'Unit' }}]
      Um,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_DOMAIN', element: 'DomvalueL' }}]
      Modalidade,
      CalcEfetivo,
      PercentualBcIcms,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt



}
