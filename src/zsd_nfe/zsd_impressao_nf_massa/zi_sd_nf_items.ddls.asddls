@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Itens da J_1BNFLIN'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_NF_ITEMS
  as select from    j_1bnflin as _Lin

  //left outer join vbrk      as _Vbrk on _Vbrk.belnr = left( _Lin.refkey, 10 )
    left outer join vbrk      as _Vbrk on _Vbrk.vbeln = left(
      _Lin.refkey, 10
    )

  association [0..1] to ZI_SD_NF_MASSA_COMPL as _Comp on _Comp.Vbeln = $projection.Refkey
{

  key _Lin.docnum         as Docnum,
      _Lin.refkey         as Refkey,
      _Lin.werks          as Werks,
      max( _Comp.Tor_id ) as Tor_id,
      _Comp.StopOrder     as StopOrder,
      _Vbrk.fkart         as Fkart,
      _Vbrk.vbtyp         as Vbtyp,
      _Vbrk.belnr         as Belnr
}
group by
  _Lin.docnum,
  _Lin.refkey,
  _Lin.werks,
  _Comp.StopOrder,
  _Vbrk.fkart,
  _Vbrk.vbtyp,
  _Vbrk.belnr
