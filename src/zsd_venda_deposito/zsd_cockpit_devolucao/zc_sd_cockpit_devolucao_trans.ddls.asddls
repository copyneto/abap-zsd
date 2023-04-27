@EndUserText.label: 'Projection Cockpit Devolução Aba Transporte'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_SD_COCKPIT_DEVOLUCAO_TRANS
  as projection on ZI_SD_COCKPIT_DEVOLUCAO_TRANS
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
      @EndUserText.label: 'CNPJ/CPF'
      CNPJ,
      @Consumption.valueHelpDefinition: [{
      entity: { name: 'ZI_CA_VH_PARTNER',
      element: 'Parceiro' }
      }]
      @EndUserText.label: 'Motorista'
      Motorista,
      @EndUserText.label: 'Placa'
      Placa,
      Tipo_Expedicao,
      @Consumption.valueHelpDefinition: [{
      entity: { name: 'ZI_CA_VH_LIFNR',
      element: 'LifnrCode' }
      }]
      @EndUserText.label: 'Transportadora'
      Transportadora,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      /* Associations */
      _Cockpit : redirected to parent ZC_SD_COCKPIT_DEVOLUCAO
}
