@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface ordem de vendas via Excel'
define root view entity ZI_SD_ORDEM_VENDAS_EXCEL
  as select from ztsd_ordvend_xls
  composition [0..*] of ZI_SD_ORDEM_VENDAS_UPLD as _SalesDocument
{
  key salesdocument         as SalesDocument,
      salesdocumenttype     as SalesDocumentType,
      salesorganization     as SalesOrganization,
      distributionchannel   as DistributionChannel,
      sddocumentreason      as SDDocumentReason,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _SalesDocument 
}
