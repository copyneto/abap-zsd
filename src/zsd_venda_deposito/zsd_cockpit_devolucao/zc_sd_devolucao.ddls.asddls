@EndUserText.label: 'Cadastro devoluções clientes'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_SD_DEVOLUCAO
  as projection on ZI_SD_DEVOLUCAO
{
  key Guid,
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_BRANCH', element : 'BusinessPlace' }}]
      LocalNegocio,
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_SD_VH_TIPO_DEV', element : 'TipoDev' }}]
      TipoDevolucao,
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_REGIO_BR', element : 'Region' }}]
      Regiao,
      Ano,
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'I_CalendarMonthName', element : 'CalendarMonth' }}]
      Mes,
      Modelo,
      Serie,
      NumeroNfe,
      DigitoVerific,
      @EndUserText.label: 'CNPJ'
      @ObjectModel.text.element: ['CNPJText']
      Cnpj,
      CNPJText,
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_CUSTOMER', element : 'Customer' }}]
      Cliente,
      DtLogistica,
      DtAdministrativo,
      Motivo,
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_FORMA_PAGTO', element : 'FormaPagtoId' }}]
      FormPagamento,
      SenhaAutorizacao,
      DtLancamento,
      HrLancamento,
      Ordem,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_WERKS', element: 'WerksCode' }}]
      Centro,
      DtCriacao,
      HrCriacao,
      AgFrete,
      Placa,
      Motorista,
      TipoExpedicao,
      OrdDevolucao,
      Material,
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_SD_VH_SITUACAO_DEV', element : 'Situacao' }}]
      Situacao,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
