@EndUserText.label: 'Gestão de preço'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['Id']

define root view entity ZC_SD_COCKPIT_GESTAO_PRECO
  as projection on ZI_SD_COCKPIT_GESTAO_PRECO

{
      @EndUserText.label: 'GUID'
  key Guid,
      @EndUserText.label: 'ID'
      @ObjectModel.text.element: ['IdText']
      Id,
      IdText,
      @EndUserText.label: 'Status'
      @ObjectModel.text.element: ['StatusText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_GESTAO_PRECO_STATUS', element: 'Status' } }]
      Status,
      _Status.StatusText               as StatusText,
      StatusCriticality,

      hiddenITM,
      hiddenMIN,
      hiddenINV,

      @EndUserText.label: 'Tipo de condição'
      @ObjectModel.text.element: ['ConditionTypeText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_TIPO_CONDICAO', element: 'ConditionType' } }]
      ConditionType,
      _ConditionType.ConditionTypeText as ConditionTypeText,
      PresentationType,
      @EndUserText.label: 'Usuário Solicitante'
      @ObjectModel.text.element: ['RequestUserText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_USER', element: 'Bname' } }]
      RequestUser,
      _RequestUser.Text                as RequestUserText,
      //      @EndUserText.label: 'Usuário Aprovador'
      //      @ObjectModel.text.element: ['ApproveUserText']
      //      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_USER', element: 'Bname' } }]
      //      ApproveUser,
      //      _ApproveUser.Text                as ApproveUserText,
      //      ApproveUserCriticality,
      @EndUserText.label: 'Centro'
      //      @ObjectModel.text.element: ['PlantText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } }]
      Plant,
      _Plant.WerksCodeName             as PlantText,
      PlantCriticality,
      @EndUserText.label: 'Data do Processamento'
      ProcessDate,
      @EndUserText.label: 'Hora do Processamento'
      ProcessTime,
      @EndUserText.label: 'Hora da Importação'
      ImportTime,
      @EndUserText.label: 'Criado por'
      @ObjectModel.text.element: ['CreatedByText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_USER', element: 'Bname' } }]
      CreatedBy,
      _CreatedBy.Text                  as CreatedByText,
      @EndUserText.label: 'Criado em'
      CreatedAt,
      @EndUserText.label: 'Alterado por'
      @ObjectModel.text.element: ['LastChangedByText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_USER', element: 'Bname' } }]
      LastChangedBy,
      _LastChangedBy.Text              as LastChangedByText,
      @EndUserText.label: 'Alterado em'
      LastChangedAt,
      LocalLastChangedAt,

      /* Compositions */
      _Item        : redirected to composition child ZC_SD_COCKPIT_GESTAO_PRECO_ITM,
      _Minimo      : redirected to composition child ZC_SD_COCKPIT_GESTAO_PRECO_MIN,
      _Invasao     : redirected to composition child ZC_SD_COCKPIT_GESTAO_PRECO_INV,
      _Mensagem    : redirected to composition child ZC_SD_COCKPIT_GESTAO_PRECO_MSG,
      _Observacoes : redirected to composition child ZC_SD_COCKPIT_GESTAO_PRECO_OBS
}
