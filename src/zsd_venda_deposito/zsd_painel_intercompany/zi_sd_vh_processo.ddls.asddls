@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Search Help - Processo'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_SD_VH_PROCESSO
  as select from dd07l as Domain
  association     to dd07t          as _Text  on  $projection.Domname  = _Text.domname
                                              and $projection.As4local = _Text.as4local
                                              and $projection.Valpos   = _Text.valpos
                                              and $projection.As4vers  = _Text.as4vers
                                              and _Text.ddlanguage     = $session.system_language

{

      @UI.hidden: true
  key domname      as Domname,
      @UI.hidden: true
  key as4local     as As4local,
      @UI.hidden: true
  key valpos       as Valpos,
      @UI.hidden: true
  key as4vers      as As4vers,

      @ObjectModel.text.element: ['Text']
      domvalue_l   as Processo,

      _Text.ddtext as Text,

      @UI.hidden: true
      domvalue_h   as DomvalueH,
      @UI.hidden: true
      appval       as Appval,
      @UI.hidden: true
      case when domvalue_l = '1'
           then 'OC01'
           else 'OC01'
      end          as Ekorg,
      @UI.hidden: true
      case when domvalue_l = '1'
           then '310'
           else '310'
      end          as Ekgrp

}
where
      Domain.domname  = 'ZD_PROCESSO'
  and Domain.as4local = 'A';
