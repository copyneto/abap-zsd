@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Rel. Fiscal NF Saída Ordem de vendas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zi_Sd_Rel_Fiscal_Saida_Ov
  as select from I_BillingDocExtdItemBasic
{
  key BillingDocument,
  key BillingDocumentItem,
      SalesDocument,
      SalesDocumentItem,
      SalesDocumentItemCategory,
      SalesOffice,
      SalesOrganization,
      DistributionChannel,    
      //      BillingCompanyCode,
      CostCenter,
      CompanyCode,
      OrganizationDivision,
      SDDocumentReason,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      ItemNetWeight,
      ItemWeightUnit
}
