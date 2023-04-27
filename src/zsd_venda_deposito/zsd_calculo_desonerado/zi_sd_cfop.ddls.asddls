@EndUserText.label: 'Busca dos valores do CFOP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_CFOP as select from j_1bagn as J_1bagn
  join j_1bagnt as _Text on  _Text.cfop = j_1bagn.cfop
                         and _Text.cfotxt <> ''
                         and  _Text.spras = $session.system_language
{
//      @Search.ranking: #MEDIUM
//      @Search.defaultSearchElement: true
  key cast( j_1bagn.cfop as abap.char( 10 ) )  as Cfop,
  max(j_1bagn.version) as Version,
  _Text.cfotxt as Text
}
group by
    j_1bagn.cfop,
    _Text.cfotxt

