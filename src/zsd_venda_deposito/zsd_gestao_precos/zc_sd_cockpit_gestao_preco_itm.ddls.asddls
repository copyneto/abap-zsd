@EndUserText.label: 'Gestão de preço - Item'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define view entity ZC_SD_COCKPIT_GESTAO_PRECO_ITM
  as projection on ZI_SD_COCKPIT_GESTAO_PRECO_ITM
{
      @EndUserText.label: 'GUID'
  key Guid,
      @EndUserText.label: 'Linha GUID'
  key GuidLine,
      @EndUserText.label: 'Linha'
      @ObjectModel.text.element: ['LineText']
      Line,
      LineText,
      LineCriticality,
      @EndUserText.label: 'Status'
      @ObjectModel.text.element: ['StatusText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_GESTAO_PRECO_STATUS', element: 'Status' } }]
      Status,
      _Status.StatusText               as StatusText,
      StatusCriticality,
      @EndUserText.label: 'Tipo de operação'
      @ObjectModel.text.element: ['OperationTypeText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_GESTAO_PRECO_TP_OPER', element: 'OperationType' } }]
      OperationType,
      _OperationType.OperationTypeText as OperationTypeText,
      OperationTypeCriticality,
      @EndUserText.label: 'Canal de Distribuição'
      //      @ObjectModel.text.element: ['DistChannelText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VTWEG', element: 'CanalDistrib' } }]
      DistChannel,
      _DistChannel.CanalDistribText    as DistChannelText,
      DistChannelCriticality,
      @EndUserText.label: 'Lista de Preço'
      //      @ObjectModel.text.element: ['PriceListText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PLTYP', element: 'PriceList' } }]
      PriceList,
      _PriceList.PriceListText         as PriceListText,
      PriceListCriticality,
      @EndUserText.label: 'Família'
      @ObjectModel.text.element: ['FamilyText']
      Family,
      _Info._FamilyText.bezek          as FamilyText,
      @EndUserText.label: 'Marca'
      @ObjectModel.text.element: ['BrandText']
      Brand,
      _Info._BrandText.bezek           as BrandText,
      @EndUserText.label: 'Material'
      //      @ObjectModel.text.element: ['MaterialText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MATERIAL', element: 'Material' } }]
      Material,
      _Material.Text                   as MaterialText,
      MaterialCriticality,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } }]
      Plant,
      _Plant.WerksCodeName             as PlantText,
      PlantCriticality,
      @EndUserText.label: 'Escala'
      Scale,
      ScaleCriticality,
      @EndUserText.label: 'Unidade de Medida'
      BaseUnit,
      BaseUnitCriticality,
      @EndUserText.label: 'Valor Mínimo'
      MinValue,
      MinValueCriticality,
      @EndUserText.label: 'Valor Sugerido'
      SugValue,
      SugValueCriticality,
      @EndUserText.label: 'Valor Máximo'
      MaxValue,
      MaxValueCriticality,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CurrencyStdVH', element: 'Currency' } }]
      @EndUserText.label: 'Moeda'
      Currency,
      CurrencyCriticality,
      @EndUserText.label: 'Condição'
      ConditionRecord,
      _ConditionRecord.ConditionRecordCriticality,
      @EndUserText.label: 'Data desde'
      DateFrom,
      DateFromCriticality,
      @EndUserText.label: 'Data até'
      DateTo,
      DateToCriticality,
      @EndUserText.label: 'Mínimo'
      Minimum,
      MinimumCriticality,
      @EndUserText.label: 'Mínimo (%)'
      MinimumPerc,
      MinimumPercCriticality,
      @EndUserText.label: 'Valor Mínimo (%)'
      MinValuePerc,
      MinValuePercCriticality,
      @EndUserText.label: 'Valor Máximo (%)'
      MaxValuePerc,
      MaxValuePercCriticality,
      @EndUserText.label: 'Valor Sugerido (%)'
      SugValuePerc,
      SugValuePercCriticality,

      @EndUserText.label: 'Valor Mínimo S4'
      ActiveMinValue,
      @EndUserText.label: 'Valor Sugerido S4'
      ActiveSugValue,
      @EndUserText.label: 'Valor Máximo S4'
      ActiveMaxValue,
      @EndUserText.label: 'Moeda S4'
      ActiveCurrency,
      @EndUserText.label: 'Condição S4'
      ActiveConditionRecord,
      @UI.hidden: true
      DeleteItem,

      @EndUserText.label: 'Criado por'
      CreatedBy,
      @EndUserText.label: 'Criado em'
      CreatedAt,
      @EndUserText.label: 'Alterado por'
      LastChangedBy,
      @EndUserText.label: 'Alterado em'
      LastChangedAt,
      LocalLastChangedAt,

      /* Associations */
      _Cockpit : redirected to parent ZC_SD_COCKPIT_GESTAO_PRECO
}
