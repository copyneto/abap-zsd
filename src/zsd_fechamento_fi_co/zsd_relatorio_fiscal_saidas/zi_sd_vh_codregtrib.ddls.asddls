@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cód. Regime Tributário'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_VH_CODREGTRIB   as select from dd07l as Objeto
    join         dd07t as Text
      on  Text.domname    = Objeto.domname
      and Text.as4local   = Objeto.as4local
      and Text.valpos     = Objeto.valpos
      and Text.as4vers    = Objeto.as4vers
      and Text.ddlanguage = $session.system_language

{
      @UI.textArrangement: #TEXT_ONLY
//      @ObjectModel.text.element: ['Descricao']
  key cast ( substring( Objeto.domvalue_l, 1, 1 ) as ze_visao preserving type ) as CRT,

//      @UI.hidden: true
      substring ( Text.ddtext, 1, 60 )                                          as Descricao

}
where
      Objeto.domname  = 'J_1BCRTN'
  and Objeto.as4local = 'A'
