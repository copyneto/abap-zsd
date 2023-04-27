@EndUserText.label: 'Projection Cockpit Devolução Aba Informações'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_SD_COCKPIT_DEVOLUCAO_INFOS
  as projection on ZI_SD_COCKPIT_DEVOLUCAO_INFOS
{
      @UI.hidden: true
  key Guid,
      Regiao,
      Ano,
      Mes,
      Modelo,
      Serie,
      @EndUserText.label: 'Dígito verificador'
      DigitoVerific,
      Local_Negocio,
      Tipo_Devolucao,
      @EndUserText.label: 'Nº Nf-e'
      NumNFE,
      @EndUserText.label: 'CNPJ'
      @ObjectModel.text.element: ['CNPJText']
      CNPJ,
      @UI.hidden: true
      CNPJText,
      Ordem_Info,
      Cliente_Info,
      MoedaSd,
      @EndUserText.label: 'Total NF-e'
      NFE_Total,
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_SITUACAO_DEV', element: 'Situacao' }}]
      @ObjectModel.text.element: [ 'StatusText' ]
      Situacao,
      @UI.hidden: true
      StatusText,
      @UI.hidden: true
      CorSituacao,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,


      /* associations */
      _Cockpit : redirected to parent ZC_SD_COCKPIT_DEVOLUCAO
}
