@EndUserText.label: 'Condições deduzidas da base PIS COFINS'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_COND_PIS_CONFIS
  as projection on ZI_SD_COND_PIS_CONFIS
{
      @Consumption.valueHelpDefinition: [{entity: {name: 'I_COMPANYCODEVH', element: 'CompanyCode' }}]
  key Bukrs,
  key DataDev,
      DataFim,
      IcmsAmt,
      IcmsFcpAmt,
      @EndUserText.label: 'ICMS Partilha'
      IcmsDestPartAmt,
      @EndUserText.label: 'ICMS Partilha FCP'
      IcmsFcpPartilhaAmt,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
