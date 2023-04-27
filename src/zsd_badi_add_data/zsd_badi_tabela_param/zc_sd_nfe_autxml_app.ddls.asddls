@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'NFE - Autorização para obter XML'
@Metadata.allowExtensions: true
define root view entity ZC_SD_NFE_AUTXML_APP
  as projection on ZI_SD_NFE_AUTXML
{
      @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_BRANCH', element: 'BusinessPlace' }}]
  key LocalNegocios,
      @EndUserText.label: 'Cnpj'
      Cnpj,
      @EndUserText.label: 'Cpf'
      Cpf,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt

}
