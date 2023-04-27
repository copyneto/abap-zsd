@EndUserText.label: 'Projection Cockpit Gerar Devolução'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_COCKPIT_DEVOLUCAO_GERDEV
  as projection on ZI_SD_COCKPIT_DEVOLUCAO_GERDEV
{
      @UI.hidden: true
  key Guid,
      LocalNegocio,
      @Consumption.valueHelpDefinition: [{
      entity: { name: 'ZI_SD_VH_ENABLE_NFE',element: 'TipoDev' }}]
      @ObjectModel.text.element:['TipoDevText']
      TpDevolucao as TipoDevolucao,
      @UI.hidden: true
      TipoDevText,
      Regiao,
      Ano,
      Mes,
      Cnpj,
      Modelo,
      Serie,
      @EndUserText.label: 'Número NF-e'
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_NOTA_DEVOLUCAO', element: 'Nfe' } }]
      NumNFe,
      DigitoVerific,
      @UI.hidden: true
      Material,
      @EndUserText.label: 'Data Lançamento'
      DataLancamento,
      @UI.hidden: true
      CodMoeda,
      ValorTotalNFe,
      //      @UI.hidden: true
      //      CodigoEAN,
      @Consumption.valueHelpDefinition: [ { entity:  { name:    'I_Customer_VH', element: 'Customer' } }]
      Cliente,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_SITUACAO_DEV', element: 'Situacao' }}]
      @ObjectModel.text.element: [ 'StatusText' ]
      Situacao,
      @UI.hidden: true
      CorSituacao,
      @UI.hidden: true
      StatusText,
      @Consumption.valueHelpDefinition: [{
      entity: { name: 'I_SDDocumentReason',
      element: 'SDDocumentReason' }
      }]
      @ObjectModel.text.element: ['SDDocumentReasonText']
      Motivo,
      @Consumption.valueHelpDefinition: [{
      entity: { name: 'ZI_CA_VH_LIFNR',
      element: 'LifnrCode' }
      }]
      @EndUserText.label: 'Transportadora'
      Transportadora,
      @Consumption.valueHelpDefinition: [{
      entity: { name: 'ZI_CA_VH_PARTNER',
      element: 'Parceiro' }
      }]
      @EndUserText.label: 'Motorista'
      Motorista,
      ChaveAcesso,
      ValorUnit,
      @UI.hidden: true
      Quantidade,
      UnidMedida,
      Fatura,
      @UI.hidden: true
      Item,
      @UI.hidden: true
      UnMedidaFatura,
      @UI.hidden: true
      QuantidadeFatura,
      @UI.hidden: true
      ValorUnitFatura,
      TotalFatura,
      @UI.hidden: true
      BrutoFatura,
      @UI.hidden: true
      AceitaValores,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_WERKS', element: 'WerksCode' }}]
      Centro,
      Created_At,
      Created_By,
      Last_Changed_At,
      Last_Changed_By,
      Local_Last_Changed_At,
      @UI.hidden: true
      SDDocumentReasonText,

      /* Associations */
      _RefVal : redirected to composition child ZC_SD_COCKPIT_DEVOLUCAO_REFVAL

}
