@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interf. - Busca Descrição Motivo Recusa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_SD_STATUS_RECUSA_TEXT
////  as select from vbap
////    association to tvagt as _DocVenda on vbap.abgru = _DocVenda.abgru
////                                      and _DocVenda.spras = 'P'
////  
////{
////    key vbeln,
////        abgru,
////        _DocVenda.bezei as DescMotivoRecusa
////}
////where vbap.posnr = '000010'
  as select from dd07l as Domain
  association to dd07t as _Text on  $projection.Domname  = _Text.domname
                                and $projection.As4local = _Text.as4local
                                and $projection.Valpos   = _Text.valpos
                                and $projection.As4vers  = _Text.as4vers
                                and _Text.ddlanguage     = $session.system_language
  
{
  key domname      as Domname,
      @UI.hidden: true
  key as4local     as As4local,
      @UI.hidden: true
  key valpos       as Valpos,
      @UI.hidden: true
  key as4vers      as As4vers,


      domvalue_l   as DomvalueL,

      _Text.ddtext as DescMotivoRecusa,

      @UI.hidden: true
      domvalue_h   as DomvalueH,
      @UI.hidden: true
      appval       as Appval
}
where
      Domain.domname  = 'STATV'
  and Domain.as4local = 'A';
