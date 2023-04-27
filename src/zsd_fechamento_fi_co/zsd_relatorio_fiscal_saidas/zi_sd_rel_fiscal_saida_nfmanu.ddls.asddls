@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'NF Manual/Criada automaticamente'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REL_FISCAL_SAIDA_NFMANU
  as select from    dd07l as Domain
    left outer join dd07t as _Text
      on  _Text.domname    = Domain.domname
      and _Text.as4local   = Domain.as4local
      and _Text.valpos     = Domain.valpos
      and _Text.as4vers    = Domain.as4vers
      and _Text.ddlanguage = $session.system_language
{
      @ObjectModel.text.element: ['Descricao']
  key Domain.domvalue_l as TipoNF,
      _Text.ddtext      as Descricao
}
where
  Domain.domname = 'J_1BMANUAL'
