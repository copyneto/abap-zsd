@EndUserText.label: 'App Monitor de Campanhas Promocionais'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_MONITOR_CAMPANHA
  as projection on ZI_SD_MONITOR_CAMPANHA
{
  key Id,
      Promocao,
      Nome,
      Cpf,
      Endereco,
      Numero,
      Complemento,
      Referencia,
      Cep,
      Bairro,
      Cidade,
      Estado,
      Email,
      Ddd,
      Telefone,
      Codigo,
      Clube,
      Maquina,
      NrSerie,
      DtCompra,
      LocalCompra,
      EndLoja,
      NotaFiscal,
      DtCadastro,
      DtEdicao,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STAUSMONPROMO', element: 'StatusId' }}]
      @ObjectModel.text.element: ['StatusText']
      Status,
      StatusText,
      StatusColor,
      Observacao,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STAUSMONPROMO', element: 'StatusId' }}]
      @ObjectModel.text.element: ['EquipeStatustxt']
      EquipeStatus,
      EquipeStatustxt,
      EquipeStatuscolor,
      EquipeObs,
      EquipeRastreio,
      EquipeNf,
      Ip,
      UserAgente,
      CadastroSac,
      OptNews,
      DtCriacao,
      HrCriacao,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Data Criação'
      DtRegistro,
      HrObjtoCriado,
      NomeRespObjto,
      CodEliminacao,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_CUSTOMER', element: 'Customer' }}]
      Bp,
      DtCriacaoCliente,
      NomeRespCliente,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STAUSMONPROMO', element: 'StatusId' }}]
      @ObjectModel.text.element: ['StatusBptext']
      StatusBp,
      StatusBptext,
      StatusBpColor,
      CodMaqSap,
      DtCriacaoEquip,
      ResponsCriacaoEquip,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STAUSMONPROMO', element: 'StatusId' }}]
      @ObjectModel.text.element: ['StatusCriacaoEquiptext']
      StatusCriacaoEquip,
      StatusCriacaoEquiptext,
      StatusCriacaoEquipColor,
      DocOv,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STAUSMONPROMO', element: 'StatusId' }}]
      @ObjectModel.text.element: ['StatusOvtext']
      StatusOv,
      StatusOvtext,
      StatusOvColor,
      Forn,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STAUSMONPROMO', element: 'StatusId' }}]
      @ObjectModel.text.element: ['StatusFornSaptext']
      StatusFornSap,
      StatusFornSaptext,
      StatusFornSapColor,
      DocFat,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STAUSMONPROMO', element: 'StatusId' }}]
      @ObjectModel.text.element: ['StatusFattext']
      StatusFat,
      StatusFattext,
      StatusFatColor,
      NrNfe,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      @EndUserText.label: 'Liberar Id dos registros selecionados?'
      LiberaId
}
