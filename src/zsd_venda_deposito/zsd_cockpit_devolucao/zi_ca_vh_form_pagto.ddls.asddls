@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Searh Help Forma de Pagamento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_CA_VH_FORM_PAGTO
  as select from t042z as FormaPagto
  association to t042zt as _Text on  $projection.FormaPagtoId = _Text.zlsch
                                 and $projection.Pais         = _Text.land1
                                 and _Text.spras              = $session.system_language

{

  key land1       as Pais,
      @ObjectModel.text.element: ['Texto']
      @Search.defaultSearchElement: true
  key zlsch       as FormaPagtoId,
      @Search.defaultSearchElement: true
      _Text.text2 as Texto

}
where
  FormaPagto.land1 = 'BR'
group by
  land1,
  zlsch,
  _Text.text2
