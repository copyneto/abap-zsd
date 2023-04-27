@EndUserText.label: 'Separação de ICMS e FCP por Estado'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['SalesOrgID','BusinessPlaceID']
define root view entity ZC_SD_FECOP_ICMS
  as projection on ZI_SD_FECOP_ICMS
{
      @Consumption.valueHelpDefinition: [{
          entity: {
              name: 'ZI_SD_SALES_ORG_TEXT',
              element: 'SalesOrgID'
          }
      }]
      @ObjectModel.text.element: ['SalesOrg']
  key SalesOrgID,
      @Consumption.valueHelpDefinition: [{
          entity: {
              name: 'ZI_SD_BRANCH_TEXT',
              element: 'BusinessPlace'
          },
          additionalBinding: [{
          localElement: 'SalesOrgID',
          element: 'Company',
          usage: #FILTER_AND_RESULT
          }]
      }]
      @ObjectModel.text.element: ['BusinessPlace']
  key BusinessPlaceID,
      SalesOrg,
      BusinessPlace,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt

}
