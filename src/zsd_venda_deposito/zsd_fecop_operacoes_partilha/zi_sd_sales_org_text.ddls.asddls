@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Organização de Vendas - Textos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_SD_SALES_ORG_TEXT
  as select from tvko as SalesOrg
  association to tvkot as _Text
    on  $projection.SalesOrgID = _Text.vkorg
    and _Text.spras            = $session.system_language

{
      @ObjectModel.text.element: ['Text']
  key vkorg       as SalesOrgID,
      @Search.defaultSearchElement: true
      _Text.vtext as Text
}

where
  SalesOrg.hide = ''
