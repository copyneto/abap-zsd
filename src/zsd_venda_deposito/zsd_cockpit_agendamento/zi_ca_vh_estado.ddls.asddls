@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Status'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
  }

define view entity ZI_CA_VH_ESTADO
  as select from dd07l as _Domain
    inner join   dd07t as _Text on  _Text.domname    = _Domain.domname
                                and _Text.as4local   = _Domain.as4local
                                and _Text.valpos     = _Domain.valpos
                                and _Text.as4vers    = _Domain.as4vers
                                and _Text.ddlanguage = $session.system_language
{
      @ObjectModel.text.element: ['Texto']
      @UI.textArrangement: #TEXT_ONLY
  key _Domain.domvalue_l as Valor,
      _Text.ddtext       as Texto
}
where
      _Domain.as4local = 'A'
  and _Domain.domname  = 'ZD_STATUS'
