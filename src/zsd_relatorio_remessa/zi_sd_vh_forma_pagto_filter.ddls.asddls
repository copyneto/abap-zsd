@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Value Help: Forma Pagto. do Fornecedor'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
define view entity ZI_SD_VH_FORMA_PAGTO_FILTER
  as select from t042z as FormaPagto
{

      @ObjectModel.text.element: ['Descricao']
      @Search.defaultSearchElement: true
  key zlsch as FormaPagtoId,
      @Search.defaultSearchElement: true
      text1 as Descricao

}
where
  land1 = 'BR'
