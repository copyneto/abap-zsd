@EndUserText.label: 'Gestão de preço - Alerta mínimo'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define view entity ZC_SD_COCKPIT_GESTAO_PRECO_MIN
  as projection on ZI_SD_COCKPIT_GESTAO_PRECO_MIN
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
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } }]
      Plant,
      _Plant.WerksCodeName             as PlantText,
      PlantCriticality,
      @EndUserText.label: 'Família'
      @ObjectModel.text.element: ['FamilyText']
      Family,
      _Info._FamilyText.bezek          as FamilyText,
      @EndUserText.label: 'Marca'
      @ObjectModel.text.element: ['BrandText']
      Brand,
      _Info._BrandText.bezek           as BrandText,
      @EndUserText.label: 'Canal de Distribuição'
      //      @ObjectModel.text.element: ['DistChannelText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VTWEG', element: 'CanalDistrib' } }]
      DistChannel,
      _DistChannel.CanalDistribText    as DistChannelText,
      DistChannelCriticality,
      @EndUserText.label: 'Material'
      //      @ObjectModel.text.element: ['MaterialText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MATERIAL', element: 'Material' } }]
      Material,
      _Material.Text                   as MaterialText,
      MaterialCriticality,
      @EndUserText.label: 'Valor'
      MinValue,
      MinValueCriticality,
      @EndUserText.label: 'Moeda'
      Currency,
      CurrencyCriticality,
      @EndUserText.label: 'Data desde'
      DateFrom,
      DateFromCriticality,
      @EndUserText.label: 'Data até'
      DateTo,
      DateToCriticality, 
      @EndUserText.label: 'Condição'
      ConditionRecord,
      _ConditionRecord.ConditionRecordCriticality,
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
